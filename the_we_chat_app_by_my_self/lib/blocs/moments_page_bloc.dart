import 'dart:io';

import 'package:flutter/foundation.dart';

class MomentsPageBloc extends ChangeNotifier {
  File? chosenCoverImage;
  bool isDisposed = false;
  String momentImage="https://elm.umaryland.edu/voices-and-opinions/Voices--Opinions-Content/Online-Education.jpg";

  void onChosenCoverImage(File? imageFile) {
    chosenCoverImage = imageFile;
    _notifySafely();
  }

  void _notifySafely() {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
