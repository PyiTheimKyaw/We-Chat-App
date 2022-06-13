import 'dart:io';

import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

abstract class WeChatDataAgent{
  Stream<List<MomentVO>> getMoments();
  Future<void> addNewMoment(MomentVO newMoment);
  Future<void> deleteMoment(int momentId);
  Stream<MomentVO> getMomentById(int momentId);
  Future<String> uploadFileToFirebase(File file);


  ///Authentication
  Future registerNewUser(UserVO newUser);
  Future<void> loginUser(String email,String password);
  bool isLoggedIn();

}