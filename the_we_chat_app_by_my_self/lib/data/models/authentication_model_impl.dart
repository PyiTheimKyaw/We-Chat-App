import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/network/cloud_fire_store_data_agent_impl.dart';
import 'package:the_we_chat_app_by_my_self/network/we_chat_data_agent.dart';

class AuthenticationModelImpl extends AuthenticationModel {
  ///Data Agent
  WeChatDataAgent mDataAgent = CloudFireStoreDataAgentImpl();

  /// Firebase Messaging Instance
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  ////Firebase auth
  FirebaseAuth auth=FirebaseAuth.instance;
  @override
  Future<void> register(String userName, String email, String password,
      String phoneNumber, File? profileImage) {
    if (profileImage != null) {
      return mDataAgent
          .uploadFileToFirebase(profileImage)
          .then((downloadUrl) => craftNewUserVO(
              userName, email, password, phoneNumber, downloadUrl))
          .then((newUser) => mDataAgent.registerNewUser(newUser));
    } else {
      return craftNewUserVO(userName, email, password, phoneNumber,
              "https://th.bing.com/th/id/OIP.TpqSE-tsrMBbQurUw2Su-AHaHk?pid=ImgDet&rs=1")
          .then((newUser) => mDataAgent.registerNewUser(newUser));
    }
  }

  Future<UserVO> craftNewUserVO(String userName, String email, String password,
      String phoneNumber, String? profilePicture) {
    return getFcmToken().then((fcmToken) {
      print("FCM TOKEN AR MODEL => $fcmToken");
      UserVO newUser = UserVO(
          userName: userName,
          id: "",
          email: email,
          password: password,
          phoneNumber: phoneNumber,
          profilePicture: profilePicture,
          qrCode: "",
          coverPicture: "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png?w=640",
          fcmToken: fcmToken);
      return Future.value(newUser);
    });
  }

  Future getFcmToken() {
    return messaging.getToken();
  }

  @override
  Future<void> login(String email, String password) {
    return mDataAgent.loginUser(email, password);
  }

  @override
  bool isLoggedIn() {
    return mDataAgent.isLoggedIn();
  }

  @override
  Future<void> logOut() {
    return mDataAgent.logOut();
  }

  @override
  UserVO getLoggedInUser() {
    return mDataAgent.getLoggedInUser();
  }

  @override
  Future<void> changeCoverPicture(UserVO newUser, File coverImage) {
    return mDataAgent.uploadFileToFirebase(coverImage).then((downloadUrl) {
      newUser.coverPicture = downloadUrl;
      return mDataAgent.addNewUser(newUser);
    });
  }

  @override
  Future<void> changeProfilePicture(UserVO newUser, File profileImage) {
    return mDataAgent.uploadFileToFirebase(profileImage).then((downloadUrl) {
      auth.currentUser?.updatePhotoURL(downloadUrl);
      newUser.profilePicture = downloadUrl;
      return mDataAgent.addNewUser(newUser);
    });
  }
}
