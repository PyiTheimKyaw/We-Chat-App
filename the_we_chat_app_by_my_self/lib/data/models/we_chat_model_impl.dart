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

  @override
  Stream<List<MomentVO>> getMoments() {
    return mDataAgent.getMoments();
  }

  @override
  Future<void> addNewMoment(String description) {
    var newMoment = MomentVO(
        id: DateTime.now().millisecond,
        description: description,
        postFile: null,
        profilePicture:
            "https://sm.askmen.com/t/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.1200.jpg",
        userName: "Pyi Theim Kyaw");
    return mDataAgent.addNewMoment(newMoment);
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
  Future<void> editMoment(MomentVO editMoment) {
    return mDataAgent.addNewMoment(editMoment);
  }
}
