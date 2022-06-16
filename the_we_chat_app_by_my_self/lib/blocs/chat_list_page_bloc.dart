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
    // filterList.clear();
    // // chattedUsersList?.clear();
    // _notifySafely();
    mModel.getChattedUser().listen((usersIdList) {
      print("Id list => ${usersIdList.length}");
      // filterList.clear();
      chattedUsersList?.clear();
      _notifySafely();
      usersIdList.forEach((userId) {

        // filterList.clear();
        // chattedUsersList?.clear();
        mModel.getUserByQRCode(userId ?? "").listen((user) {
          mModel.getConversion(user).listen((event) {
            user.conversationList=event;
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
