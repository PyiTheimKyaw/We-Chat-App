import 'dart:io';

import 'package:the_we_chat_app_by_my_self/data/vos/favourite_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/message_vo.dart';
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
  Future<void> addNewUser(UserVO newUser);
  Future<void> loginUser(String email,String password);
  bool isLoggedIn();
  Future logOut();
  UserVO getLoggedInUser();
  Stream<UserVO> getUserByQRCode(String qrCode);
  Future<void> addAnotherUserContact(UserVO user);
  Future<void> sendMyInfoToAnotherUser(UserVO user);
  Stream<List<UserVO>> getContacts();

  ///Comment and favourite
  Stream<List<CommentVO>> getComments(int momentId);
  Future<void> addComment(CommentVO newMessage,int momentId);
  Stream<List<FavouriteVO>> getAllReacts(int momentId);
  Future<void> reactMoment(FavouriteVO favourite,int momentId);
  Future<void> unReact(int momentId);
}