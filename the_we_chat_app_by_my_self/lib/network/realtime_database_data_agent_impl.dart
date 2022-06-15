import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/network/chatting_data_agent.dart';

///Nodes
const contactsAndMessages = "contactsAndMessages";

class RealTimeDatabaseDataAgentImpl extends ChattingDataAgent {
  static final RealTimeDatabaseDataAgentImpl _singleton =
      RealTimeDatabaseDataAgentImpl._internal();

  factory RealTimeDatabaseDataAgentImpl() {
    return _singleton;
  }

  RealTimeDatabaseDataAgentImpl._internal();

  ///Auth
  final FirebaseAuth auth = FirebaseAuth.instance;

  ///Database
  var databaseRef = FirebaseDatabase.instance.reference();

  @override
  Future<void> sendMessageFromLoggedUser(
      ContactAndMessageVO chatMessage, UserVO chatUser) {
    return databaseRef
        .child(contactsAndMessages)
        .child(auth.currentUser?.uid ?? "")
        .child(chatUser.id ?? "")
        .child(chatMessage.timeStamp.toString())
        .set(chatMessage.toJson());
  }

  @override
  Future<void> sendMessageFromChatUser(
      ContactAndMessageVO chatMessage, UserVO chatUser) {
    return databaseRef
        .child(contactsAndMessages)
        .child(chatUser.id ?? "")
        .child(auth.currentUser?.uid ?? "")
        .child(chatMessage.timeStamp.toString())
        .set(chatMessage.toJson());
  }

  @override
  Stream<List<ContactAndMessageVO>> getConversion(UserVO chatUser) {
    return databaseRef
        .child(contactsAndMessages)
        .child(auth.currentUser?.uid ?? "")
        .child(chatUser.id ?? "")
        .onValue
        .map((event) {
      return event.snapshot.children.map<ContactAndMessageVO>((snapShot) {
        return ContactAndMessageVO.fromJson(
            Map<String, dynamic>.from(snapShot.value as Map));
      }).toList();
    });
  }

  @override
  Stream<List<String?>> getChattedUser() {
    return databaseRef
        .child(contactsAndMessages)
        .child(auth.currentUser?.uid ?? "")
        .onValue
        .map((event) {
      return event.snapshot.children.map((snapShot) {
        return snapShot.key;
      }).toList();
    });
  }
}
