import 'dart:io';

import 'package:flutter/foundation.dart';

class AddMomentsPageBloc extends ChangeNotifier {
  File? chosenPostImage;
  bool isDisposed = false;

  void onChosenPostImage(File image) {
    chosenPostImage = image;
    _notififySafely();
  }

  void _notififySafely() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
