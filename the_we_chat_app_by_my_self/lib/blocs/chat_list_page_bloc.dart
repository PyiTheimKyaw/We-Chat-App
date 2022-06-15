import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class ChatListPageBloc extends ChangeNotifier {
  bool isDisposed = false;

  ///State
  List<UserVO>? chattedUsersList;
  List<UserVO> dummyUserList = [];
  List<String?>? chattedUserId;
  List<String> dummyMessages = [];
  List<String>? conversation;

  ///Model
  WeChatModel mModel = WeChatModelImpl();

  ChatListPageBloc() {
    mModel.getChattedUser().listen((usersIdList) {
      usersIdList.forEach((userId) {
        mModel.getUserByQRCode(userId ?? "").listen((user) {
          dummyUserList.add(user);
          chattedUsersList = dummyUserList;
          _notifySafely();
          mModel.getConversion(user).listen((messagesList) {
            dummyMessages.add(messagesList.last.messages ?? "");
            _notifySafely();
            conversation = dummyMessages;
            _notifySafely();
          });
        });
      });
    });
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
