import 'package:azlistview/azlistview.dart';
import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/az_item_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class ContactTabBloc extends ChangeNotifier {
  List<UserVO>? usersDummy;
  List<AZItemVO>? alphabetList;
  List<AZItemVO>? filterList;
  bool isDisposed = false;

  ///Model
  WeChatModel mModel = WeChatModelImpl();

  ContactTabBloc() {
    mModel.getContacts().listen((event) {
      usersDummy = event;
      _notifySafely();
      alphabetList = usersDummy
          ?.map((item) => AZItemVO(
              person: item, tag: item.userName?[0].toUpperCase() ?? ""))
          .toList();
      filterList = usersDummy
          ?.map((item) => AZItemVO(
              person: item, tag: item.userName?[0].toUpperCase() ?? ""))
          .toList();

      SuspensionUtil.sortListBySuspensionTag(filterList);
      SuspensionUtil.setShowSuspensionStatus(filterList);
    });
  }

  searchByName(String text) {
    if (text.isNotEmpty) {
      filterList = alphabetList?.where((element) {
        return element.person.userName!
            .toLowerCase()
            .contains(text.toLowerCase());
      }).toList();
    } else {
      filterList = alphabetList;
    }
    _notifySafely();
  }

  _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
