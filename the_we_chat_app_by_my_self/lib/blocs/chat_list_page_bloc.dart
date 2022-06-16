import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class ChatListPageBloc extends ChangeNotifier {
  bool isDisposed = false;

  ///State
  List<UserVO>? chattedUsersList;

  Set<UserVO> filterList = {};
  List<String?>? chattedUserId;

  ///Model
  WeChatModel mModel = WeChatModelImpl();

  ChatListPageBloc() {
    filterList = {};
    _notifySafely();
    mModel.getChattedUser().listen((usersIdList) {
      usersIdList.forEach((userId) {
        mModel.getUserByQRCode(userId ?? "").listen((user) {
          mModel.getConversion(user).listen((messagesList) {
            user.conversationList = messagesList;
            filterList.add(user);
            _notifySafely();
            print("Set user List ${filterList.toString()}");
            chattedUsersList = filterList.toList();
            _notifySafely();
          });
        });
      });
      filterList = {};
      _notifySafely();
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
