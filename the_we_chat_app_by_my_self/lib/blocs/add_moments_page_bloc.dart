import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class AddMomentsPageBloc extends ChangeNotifier {
  File? chosenPostImage;
  String? fileType;
  bool isDisposed = false;
  int currentIndex = 0;
  bool isDrawerPop = false;
  bool isAddNewMomentError = false;
  bool isInEditMode = false;
  bool isLoading = false;
  UserVO? _loggedInUser;

  ///Variables
  String? userName;
  String? profilePicture;
  String postImage = '';

  ///States
  String newMomentDescription = '';
  MomentVO? mMoment;
  TextEditingController textEditingController = TextEditingController();

  ///Models
  WeChatModel mModel = WeChatModelImpl();
  AuthenticationModel mAuthModel = AuthenticationModelImpl();

  AddMomentsPageBloc({int? momentId}) {
    _loggedInUser = mAuthModel.getLoggedInUser();
    if (momentId != null) {
      isInEditMode = true;
      _notifySafely();
      _prePopulateDataForEditMode(momentId);
    } else {
      isInEditMode = false;
      _notifySafely();
      _prePopulateDataForAddMode();
    }
  }

  void _prePopulateDataForEditMode(int momentId) {
    mModel.getMomentById(momentId).listen((moment) {
      userName = moment.userName;
      textEditingController.text = moment.description ?? "";
      profilePicture = moment.profilePicture ?? "";
      postImage = moment.postFile ?? "";
      fileType = moment.fileType;
      mMoment = moment;
      _notifySafely();
    });
  }

  void _prePopulateDataForAddMode() {
    userName = _loggedInUser?.userName;
    profilePicture = _loggedInUser?.profilePicture;
  }

  Future<void> onTapAddNewMoment() {
    if (textEditingController.text.isEmpty) {
      isAddNewMomentError = true;
      _notifySafely();
      return Future.error("Error");
    } else {
      isLoading = true;
      isAddNewMomentError = false;
      _notifySafely();
      if (isInEditMode) {
        return _editMoment().then((value) {
          isLoading = false;
          _notifySafely();
        });
      } else {
        return _addNewMoment().then((value) {
          isLoading = false;
          _notifySafely();
        });
      }
    }
  }

  Future<dynamic> _addNewMoment() {
    return mModel.addNewMoment(textEditingController.text, chosenPostImage,
        fileType ?? "", _loggedInUser?.id ?? "");
  }

  Future<dynamic> _editMoment() {
    mMoment?.description = textEditingController.text;
    if (mMoment != null) {
      return mModel.editMoment(mMoment!, chosenPostImage, fileType ?? "");
    } else {
      return Future.error("Error");
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
    postImage = '';
    _notifySafely();
  }

  void _notifySafely() {
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
