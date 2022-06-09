import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';

abstract class WeChatDataAgent{
  Stream<List<MomentVO>> getMoments();
  Future<void> addNewMoment(MomentVO newMoment);
  Future<void> deleteMoment(int momentId);
  Stream<MomentVO> getMomentById(int momentId);
}