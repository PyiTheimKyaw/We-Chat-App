import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';

class AddMomentsPageBloc extends ChangeNotifier {
  File? chosenPostImage;
  String? fileType;
  bool isDisposed = false;
  int currentIndex = 0;
  bool isDrawerPop = false;
  bool isAddNewMomentError = false;

  ///States
  String newMomentDescription = '';

  ///Models
  WeChatModel mModel = WeChatModelImpl();

  Future<void> onTapAddNewMoment() {
    if (newMomentDescription.isEmpty) {
      isAddNewMomentError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isAddNewMomentError = true;
      _notifySafely();
      return mModel.addNewMoment(newMomentDescription);
    }
  }

  void onNewPostTextChanged(String text) {
    newMomentDescription = text;
    _notifySafely();
  }

  Future<void> onTapMoreToDrawerPop() {
    isDrawerPop = true;
    _notifySafely();
    return Future.value();
  }

  void onChosenIndex(int index) {
    currentIndex = index;
    _notifySafely();
  }

  void onChosenPostImage(File image, String fileType) {
    chosenPostImage = image;
    this.fileType = fileType;
    _notifySafely();
  }

  void onChosenDeleteFile() {
    chosenPostImage = null;
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
