import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/network/we_chat_data_agent.dart';

///Moments Collection
const momentCollection = "moments";
const fileUploadRef = "uploads";
const userCollectionsPath = "users";

class CloudFireStoreDataAgentImpl extends WeChatDataAgent {
  static final CloudFireStoreDataAgentImpl _singleton =
      CloudFireStoreDataAgentImpl._internal();

  factory CloudFireStoreDataAgentImpl() {
    return _singleton;
  }

  CloudFireStoreDataAgentImpl._internal();

  ///Database
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  ///Storage
  var firebaseStorage = FirebaseStorage.instance;

  ///Auth
  FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Stream<List<MomentVO>> getMoments() {
    return _fireStore
        .collection(momentCollection)
        .snapshots()
        .map((querySnapShot) {
      return querySnapShot.docs.map<MomentVO>((document) {
        return MomentVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Future<void> addNewMoment(MomentVO newMoment) {
    return _fireStore
        .collection(momentCollection)
        .doc(newMoment.id.toString())
        .set(newMoment.toJson());
  }

  @override
  Future<void> deleteMoment(int momentId) {
    return _fireStore
        .collection(momentCollection)
        .doc(momentId.toString())
        .delete();
  }

  @override
  Stream<MomentVO> getMomentById(int momentId) {
    return _fireStore
        .collection(momentCollection)
        .doc(momentId.toString())
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) => MomentVO.fromJson(documentSnapShot.data()!));
  }

  @override
  Future<String> uploadFileToFirebase(File file) {
    return firebaseStorage
        .ref(fileUploadRef)
        .child("${DateTime.now().millisecondsSinceEpoch}")
        .putFile(file)
        .then((taskSnapShot) => taskSnapShot.ref.getDownloadURL());
  }

  @override
  Future registerNewUser(UserVO newUser) {
    return auth
        .createUserWithEmailAndPassword(
            email: newUser.email ?? "", password: newUser.password ?? "")
        .then((credential) {
      return credential.user
        ?..updateDisplayName(newUser.userName ?? "")
        ..updatePhotoURL(newUser.profilePicture ?? "");
    }).then((user) {
      newUser.id = user?.uid ?? "";
      newUser.qrCode = user?.uid ?? "";
      _addNewUser(newUser);
    });
  }

  Future<void> _addNewUser(UserVO newUser) {
    return _fireStore
        .collection(userCollectionsPath)
        .doc(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future<void> loginUser(String email, String password) {
    return auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  @override
  Future logOut() {
    return auth.signOut();
  }
}
