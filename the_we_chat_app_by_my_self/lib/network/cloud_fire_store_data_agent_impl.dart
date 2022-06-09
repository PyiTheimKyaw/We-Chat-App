import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/network/we_chat_data_agent.dart';

///Moments Collection
const momentCollection = "moments";
const fileUploadRef = "uploads";

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
}
