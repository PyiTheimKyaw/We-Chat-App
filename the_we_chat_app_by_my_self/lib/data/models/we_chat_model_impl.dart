import 'dart:io';

import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/network/cloud_fire_store_data_agent_impl.dart';
import 'package:the_we_chat_app_by_my_self/network/we_chat_data_agent.dart';

class WeChatModelImpl extends WeChatModel {
  static final WeChatModelImpl _singleton = WeChatModelImpl._internal();

  factory WeChatModelImpl() {
    return _singleton;
  }

  WeChatModelImpl._internal();

  ///DataAgent
  WeChatDataAgent mDataAgent = CloudFireStoreDataAgentImpl();

  ///Model
  AuthenticationModel mAuthModel = AuthenticationModelImpl();

  @override
  Stream<List<MomentVO>> getMoments() {
    return mDataAgent.getMoments();
  }

  @override
  Future<void> addNewMoment(String description, File? file, String fileType) {
    if (file != null) {
      return mDataAgent
          .uploadFileToFirebase(file)
          .then((downloadUrl) =>
              craftNewMomentVO(description, downloadUrl, fileType))
          .then((newMoment) => mDataAgent.addNewMoment(newMoment));
    } else {
      return craftNewMomentVO(description, "", "")
          .then((newMoment) => mDataAgent.addNewMoment(newMoment));
    }
  }

  Future<MomentVO> craftNewMomentVO(
      String description, String fileUrl, String fileType) {
    var newMoment = MomentVO(
        id: DateTime.now().millisecondsSinceEpoch,
        description: description,
        postFile: fileUrl,
        profilePicture:
            mAuthModel.getLoggedInUser().profilePicture,
        userName: mAuthModel.getLoggedInUser().userName,
        fileType: fileType);
    return Future.value(newMoment);
  }

  Future<MomentVO> craftEditMomentVO(
      MomentVO moment, String fileUrl, String fileType) {
    MomentVO editMoment = moment;
    editMoment.postFile = fileUrl;
    editMoment.fileType = fileType;
    return Future.value(editMoment);
  }

  @override
  Future<void> deleteMoment(int momentId) {
    return mDataAgent.deleteMoment(momentId);
  }

  @override
  Stream<MomentVO> getMomentById(int momentId) {
    return mDataAgent.getMomentById(momentId);
  }

  @override
  Future<void> editMoment(MomentVO editMoment, File? file, String fileType) {
    if (file != null) {
      return mDataAgent
          .uploadFileToFirebase(file)
          .then((downloadUrl) =>
              craftEditMomentVO(editMoment, downloadUrl, fileType))
          .then((editedMoment) => mDataAgent.addNewMoment(editedMoment));
    } else {
      return mDataAgent.addNewMoment(editMoment);
    }
  }

  @override
  Future<String> uploadFileToFirebase(File file) {
    return mDataAgent.uploadFileToFirebase(file);
  }
}
