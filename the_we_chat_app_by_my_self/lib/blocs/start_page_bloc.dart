import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/pages/start_page.dart';

class StartPageBloc extends ChangeNotifier {
  int currentIndex = 0;
  bool isDispose = false;

  StartPageBloc({int? index}) {
    if (index != null) {
      currentIndex = index;
      _notifySafely();
    }
  }

  void onChangePageIndex(int index) {
    currentIndex = index;
    _notifySafely();
  }

  void _notifySafely() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDispose = true;
  }
}
