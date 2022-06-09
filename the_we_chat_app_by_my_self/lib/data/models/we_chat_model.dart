import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';

abstract class WeChatModel{
  Stream<List<MomentVO>> getMoments();
  Future<void> addNewMoment(String description);
  Future<void> deleteMoment(int momentId);
}