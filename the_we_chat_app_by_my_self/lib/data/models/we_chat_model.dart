import 'dart:io';

import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/favourite_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

abstract class WeChatModel {
  Stream<List<MomentVO>> getMoments();

  Future<void> addNewMoment(
      String description, File? file, String fileType, String userId);

  Future<void> editMoment(MomentVO editMoment, File? file, String fileType);

  Future<void> deleteMoment(int momentId);

  Stream<MomentVO> getMomentById(int momentId);

  Future<String> uploadFileToFirebase(File file);

  Stream<UserVO> getUserByQRCode(String qrCode);

  Future<void> addAnotherUserContact(UserVO user);

  Stream<List<UserVO>> getContacts();

  Future<void> sendMessages(
      String? message, File? file, String fileType, UserVO chatUser);

  Stream<List<ContactAndMessageVO>> getConversion(UserVO chatUser);

  Stream<List<String?>> getChattedUser();

  Future deleteConversation(UserVO chatUser);

  Future<void> addComment(String userName, int momentId, String comment);

  Stream<List<CommentVO>> getComments(int momentId);

  Stream<List<FavouriteVO>> getAllReacts(int momentId);

  Future<void> reactMoment( int momentId);

  Future<void> unReact(int momentId);
}
