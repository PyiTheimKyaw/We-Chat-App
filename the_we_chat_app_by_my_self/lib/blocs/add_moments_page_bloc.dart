import 'dart:io';

import 'package:flutter/foundation.dart';

class AddMomentsPageBloc extends ChangeNotifier {
  File? chosenPostImage;
  String? fileType;
  bool isDisposed = false;
  int currentIndex=0;
  bool isDrawerPop=false;

  Future<void> onTapMoreToDrawerPop(){
    isDrawerPop=true;
    _notifySafely();
    return Future.value();
  }
  void onChosenIndex(int index){
    currentIndex=index;
    _notifySafely();
  }
  void onChosenPostImage(File image,String fileType) {
    chosenPostImage = image;
    this.fileType=fileType;
    _notifySafely();
  }
  void onChosenDeleteFile(){
    chosenPostImage=null;
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
