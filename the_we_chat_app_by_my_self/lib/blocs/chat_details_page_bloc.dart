import 'dart:io';

import 'package:flutter/foundation.dart';

class ChatDetailsPageBloc extends ChangeNotifier {
  bool isPopUp = false;
  bool isDisposed = false;
  File? chosenFile;
  String? chosenFileType;

  void onTapMoreButton(){
    isPopUp=!isPopUp;
    _notifySafely();
  }

  void onTapTextField(){
    isPopUp=false;
    _notifySafely();
  }

  void onChosenFile(File? file,String fileType){
    chosenFile=file;
    chosenFileType=fileType;
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
