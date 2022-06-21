import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/network/we_chat_data_agent.dart';

///Moments Collection
const momentCollection = "moments";
const fileUploadRef = "uploads";
const userCollectionsPath = "users";
const contactsCollectionPath = "contacts";
const commentsCollectionPath = "comments";

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
      addNewUser(newUser);
    });
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

  @override
  UserVO getLoggedInUser() {
    return UserVO(
        id: auth.currentUser?.uid,
        userName: auth.currentUser?.displayName,
        email: auth.currentUser?.email,
        profilePicture: auth.currentUser?.photoURL,
        phoneNumber: auth.currentUser?.phoneNumber,
        qrCode: auth.currentUser?.uid);
  }

  @override
  Stream<UserVO> getUserByQRCode(String qrCode) {
    return _fireStore
        .collection(userCollectionsPath)
        .doc(qrCode)
        .get()
        .asStream()
        .where((documentSnapShot) => documentSnapShot.data() != null)
        .map((documentSnapShot) => UserVO.fromJson(documentSnapShot.data()!));
  }

  @override
  Future<void> addAnotherUserContact(UserVO user) {
    return _fireStore
        .collection(userCollectionsPath)
        .doc(auth.currentUser?.uid)
        .collection(contactsCollectionPath)
        .doc(user.id)
        .set(user.toJson());
  }

  @override
  Future<void> sendMyInfoToAnotherUser(UserVO user) {
    return _fireStore
        .collection(userCollectionsPath)
        .doc(user.id)
        .collection(contactsCollectionPath)
        .doc(getLoggedInUser().id)
        .set(getLoggedInUser().toJson());
  }

  @override
  Stream<List<UserVO>> getContacts() {
    return _fireStore
        .collection(userCollectionsPath)
        .doc(auth.currentUser?.uid)
        .collection(contactsCollectionPath)
        .snapshots()
        .map((querySnapShot) {
      return querySnapShot.docs.map<UserVO>((document) {
        return UserVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Future<void> addNewUser(UserVO newUser) {
    return _fireStore
        .collection(userCollectionsPath)
        .doc(newUser.id.toString())
        .set(newUser.toJson());
  }

  @override
  Future<void> addComment(CommentVO newMessage, int momentId) {
    return _fireStore
        .collection(momentCollection)
        .doc(momentId.toString())
        .collection(commentsCollectionPath)
        .doc(newMessage.id.toString())
        .set(newMessage.toJson());
  }

  @override
  Stream<List<CommentVO>> getComments(int momentId) {
    return _fireStore
        .collection(momentCollection)
        .doc(momentId.toString())
        .collection(commentsCollectionPath)
        .snapshots()
        .map((snapShot) {
      return snapShot.docs.map<CommentVO>((document) {
        return CommentVO.fromJson(document.data());
      }).toList();
    });
  }
}
