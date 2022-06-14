import 'dart:io';

import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/network/cloud_fire_store_data_agent_impl.dart';
import 'package:the_we_chat_app_by_my_self/network/we_chat_data_agent.dart';

class AuthenticationModelImpl extends AuthenticationModel {
  ///Data Agent
  WeChatDataAgent mDataAgent = CloudFireStoreDataAgentImpl();

  @override
  Future<void> register(
      String email, String password, String phoneNumber, File? profileImage) {
    if (profileImage != null) {
      return mDataAgent
          .uploadFileToFirebase(profileImage)
          .then((downloadUrl) =>
              craftNewUserVO(email, password, phoneNumber, downloadUrl))
          .then((newUser) => mDataAgent.registerNewUser(newUser));
    } else {
      return craftNewUserVO(email, password, phoneNumber, "")
          .then((newUser) => mDataAgent.registerNewUser(newUser));
    }
  }

  Future<UserVO> craftNewUserVO(String email, String password,
      String phoneNumber, String? profilePicture) {
    UserVO newUser = UserVO(
        id: "",
        email: email,
        password: password,
        phoneNumber: phoneNumber,
        profilePicture: profilePicture,
        qrCode: "",
        fcmToken: "");
    return Future.value(newUser);
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
}
