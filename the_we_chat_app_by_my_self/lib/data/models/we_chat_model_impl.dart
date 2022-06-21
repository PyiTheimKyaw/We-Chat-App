import 'dart:io';

import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/favourite_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/network/chatting_data_agent.dart';
import 'package:the_we_chat_app_by_my_self/network/cloud_fire_store_data_agent_impl.dart';
import 'package:the_we_chat_app_by_my_self/network/realtime_database_data_agent_impl.dart';
import 'package:the_we_chat_app_by_my_self/network/we_chat_data_agent.dart';

class WeChatModelImpl extends WeChatModel {
  static final WeChatModelImpl _singleton = WeChatModelImpl._internal();

  factory WeChatModelImpl() {
    return _singleton;
  }

  WeChatModelImpl._internal();

  ///DataAgent
  WeChatDataAgent mDataAgent = CloudFireStoreDataAgentImpl();
  ChattingDataAgent mRealTimeDataAgent = RealTimeDatabaseDataAgentImpl();

  ///Model
  AuthenticationModel mAuthModel = AuthenticationModelImpl();

  @override
  Stream<List<MomentVO>> getMoments() {
    return mDataAgent.getMoments();
  }

  @override
  Future<void> addNewMoment(
      String description, File? file, String fileType, String userId) {
    if (file != null) {
      return mDataAgent
          .uploadFileToFirebase(file)
          .then((downloadUrl) =>
              craftNewMomentVO(description, downloadUrl, fileType, userId))
          .then((newMoment) => mDataAgent.addNewMoment(newMoment));
    } else {
      return craftNewMomentVO(description, "", "", userId)
          .then((newMoment) => mDataAgent.addNewMoment(newMoment));
    }
  }

  Future<MomentVO> craftNewMomentVO(
      String description, String fileUrl, String fileType, String userId) {
    var newMoment = MomentVO(
        id: DateTime.now().millisecondsSinceEpoch,
        description: description,
        postFile: fileUrl,
        profilePicture: mAuthModel.getLoggedInUser().profilePicture,
        userName: mAuthModel.getLoggedInUser().userName,
        fileType: fileType,
        timeStamp: DateTime.now().millisecondsSinceEpoch,
        userId: userId);
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

  @override
  Stream<UserVO> getUserByQRCode(String qrCode) {
    return mDataAgent.getUserByQRCode(qrCode);
  }

  @override
  Future<void> addAnotherUserContact(UserVO user) {
    return mDataAgent.addAnotherUserContact(user).then((value) {
      mDataAgent.sendMyInfoToAnotherUser(user);
    });
  }

  @override
  Stream<List<UserVO>> getContacts() {
    return mDataAgent.getContacts();
  }

  @override
  Future<void> sendMessages(
      String? message, File? file, String fileType, UserVO chatUser) {
    if (file != null) {
      return mDataAgent.uploadFileToFirebase(file)
        ..then((downloadUrl) {
          return craftNewConversion(message, downloadUrl, fileType)
              .then((conversion) {
            return mRealTimeDataAgent
                .sendMessageFromLoggedUser(conversion, chatUser)
                .then((value) {
              return mRealTimeDataAgent.sendMessageFromChatUser(
                  conversion, chatUser);
            });
          });
        });
    } else {
      return craftNewConversion(message, "", "").then((conversion) {
        return mRealTimeDataAgent
            .sendMessageFromLoggedUser(conversion, chatUser)
            .then((value) {
          return mRealTimeDataAgent.sendMessageFromChatUser(
              conversion, chatUser);
        });
      });
    }
  }

  Future<ContactAndMessageVO> craftNewConversion(
    String? message,
    String? fileUrl,
    String fileType,
  ) {
    var timeStamp = DateTime.now().millisecondsSinceEpoch;
    var conversion = ContactAndMessageVO(
        id: mAuthModel.getLoggedInUser().id ?? "",
        messages: message,
        profilePicture: mAuthModel.getLoggedInUser().profilePicture,
        file: fileUrl,
        timeStamp: timeStamp,
        userName: mAuthModel.getLoggedInUser().userName,
        fileType: fileType);
    return Future.value(conversion);
  }

  @override
  Stream<List<ContactAndMessageVO>> getConversion(UserVO chatUser) {
    return mRealTimeDataAgent.getConversion(chatUser);
  }

  @override
  Stream<List<String?>> getChattedUser() {
    return mRealTimeDataAgent.getChattedUser();
  }

  @override
  Future deleteConversation(UserVO chatUser) {
    return mRealTimeDataAgent
        .deleteConversationFromLoggedInUser(chatUser)
        .then((value) {
      return mRealTimeDataAgent.deleteConversationFromChatUser(chatUser);
    });
  }

  Future<CommentVO> craftMessageVO(String userName, String comment) {
    var milliSeconds = DateTime.now().millisecondsSinceEpoch;
    CommentVO newMessage =
        CommentVO(id: milliSeconds, userName: userName, comment: comment);
    return Future.value(newMessage);
  }

  @override
  Future<void> addComment(String userName, int momentId, String comment) {
    return craftMessageVO(userName, comment)
        .then((newMessage) => mDataAgent.addComment(newMessage, momentId));
  }

  @override
  Stream<List<CommentVO>> getComments(int momentId) {
    return mDataAgent.getComments(momentId);
  }

  @override
  Stream<List<FavouriteVO>> getAllReacts(int momentId) {
    return mDataAgent.getAllReacts(momentId);
  }

  Future<FavouriteVO> craftReactVO() {
    FavouriteVO newFavourite = FavouriteVO(
        id: mAuthModel.getLoggedInUser().id,
        userName: mAuthModel.getLoggedInUser().userName);
    return Future.value(newFavourite);
  }

  @override
  Future<void> reactMoment(int momentId) {
    return craftReactVO()
        .then((newReact) => mDataAgent.reactMoment(newReact, momentId));
  }

  @override
  Future<void> unReact(int momentId) {
    return mDataAgent.unReact(momentId);
  }
}
