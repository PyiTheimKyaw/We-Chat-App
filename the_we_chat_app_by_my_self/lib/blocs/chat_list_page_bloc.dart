import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class ChatListPageBloc extends ChangeNotifier {
  bool isDisposed = false;

  ///State
  List<UserVO>? chattedUsersList;
  List<UserVO> filterList = [];

  ///Model
  WeChatModel mModel = WeChatModelImpl();

  ChatListPageBloc() {
    mModel.getChattedUser().listen((usersIdList) {
      print("Id list => ${usersIdList.length}");

      chattedUsersList?.clear();
      _notifySafely();
      usersIdList.forEach((userId) {
        mModel.getUserByQRCode(userId ?? "").listen((user) {
          mModel.getConversion(user).listen((event) {
            List<ContactAndMessageVO> messageList = [];
            messageList.addAll(event.where(
                (element) => element.messages != "" || element.fileType != ""));
            user.conversationList = messageList;
            _notifySafely();
            filterList.add(user);
            _notifySafely();
            chattedUsersList = filterList;
            _notifySafely();
            // print(("Chatted User List => ${chattedUsersList?.last.userName}"));
            print(("Chatted User List length => ${chattedUsersList?.length}"));
          });
        });
      });
    });
  }

  void onTapDelete(int index) {
    mModel.deleteConversation(chattedUsersList?[index] ?? UserVO());
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }
}
