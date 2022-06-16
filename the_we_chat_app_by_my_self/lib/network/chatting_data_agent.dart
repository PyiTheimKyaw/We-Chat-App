import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

abstract class ChattingDataAgent{
  Future<void> sendMessageFromLoggedUser(ContactAndMessageVO chatMessage,UserVO chatUser);
  Future<void> sendMessageFromChatUser(ContactAndMessageVO chatMessage,UserVO chatUser);
  Stream<List<ContactAndMessageVO>> getConversion(UserVO chatUser);
  Stream<List<String?>> getChattedUser();
  Future deleteConversationFromLoggedInUser(UserVO chatUser);
  Future deleteConversationFromChatUser(UserVO chatUser);
}