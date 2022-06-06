import 'package:flutter/foundation.dart';

class StartPageBloc extends ChangeNotifier {
  int currentIndex = 0;
  bool isDispose = false;

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
