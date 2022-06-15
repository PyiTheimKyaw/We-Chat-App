import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class ChatListPageBloc extends ChangeNotifier {
  bool isDisposed = false;

  ///State
  List<UserVO>? chattedUsersList;

  ///Model
  WeChatModel mModel = WeChatModelImpl();

  ChatListPageBloc() {
    mModel.getChattedUser().listen((usersList) {
      print("Chat user list => ${chattedUsersList?[0].toString()}");
      mModel.getUserByQRCode(usersList.toString()).listen((event) {
        chattedUsersList?[0] = event;
        _notifySafely();

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
