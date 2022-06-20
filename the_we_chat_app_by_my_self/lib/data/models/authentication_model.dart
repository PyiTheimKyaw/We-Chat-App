import 'dart:io';

import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

abstract class AuthenticationModel{
  Future<void> register(String userName,String email,String password,String phoneNumber,File? profileImage);
  Future<void> login(String email,String password);
  bool isLoggedIn();
  Future<void> logOut();
  UserVO getLoggedInUser();
  Future<void> changeCoverPicture(UserVO newUser,File coverImage);
  Future<void> changeProfilePicture(UserVO newUser,File profileImage);
}