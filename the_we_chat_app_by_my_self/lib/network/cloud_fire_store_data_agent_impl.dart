import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/network/we_chat_data_agent.dart';

///Moments Collection
const momentCollection = "moments";

class CloudFireStoreDataAgentImpl extends WeChatDataAgent {
  static final CloudFireStoreDataAgentImpl _singleton =
      CloudFireStoreDataAgentImpl._internal();

  factory CloudFireStoreDataAgentImpl() {
    return _singleton;
  }

  CloudFireStoreDataAgentImpl._internal();

  ///Database
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  @override
  Stream<List<MomentVO>> getMoments() {
    return _fireStore
        .collection(momentCollection)
        .snapshots()
        .map((querySnapShot) {
      return querySnapShot.docs.map<MomentVO>((document) {
        return MomentVO.fromJson(document.data());
      }).toList();
    });
  }

  @override
  Future<void> addNewMoment(MomentVO newMoment) {
    return _fireStore
        .collection(momentCollection)
        .doc(newMoment.id.toString())
        .set(newMoment.toJson());
  }
}
