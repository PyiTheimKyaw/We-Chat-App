import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class ChatDetailsPageBloc extends ChangeNotifier {
  bool isPopUp = false;
  bool isDisposed = false;
  File? chosenFile;
  String? chosenFileType;
  List<ContactAndMessageVO>? conversationsList;
  UserVO? loggedInUser;
  UserVO? chatUserinfo;
  TextEditingController controller = TextEditingController();

  ///Dataagent
  WeChatModel mModel = WeChatModelImpl();
  AuthenticationModel mAuthModel = AuthenticationModelImpl();

  ChatDetailsPageBloc(UserVO chatUser) {
    chatUserinfo = chatUser;
    loggedInUser = mAuthModel.getLoggedInUser();
    _notifySafely();
    mModel.getConversion(chatUser).listen((conversion) {
      conversationsList = conversion;
      _notifySafely();
    });
  }

  void onSubmitted(String? text) {
    print("On tap submitted => $text");
    mModel
        .sendMessages(
            text, chosenFile, chosenFileType ?? "", chatUserinfo ?? UserVO())
        .then((value) {
      controller.text = '';
      chosenFile = null;
      _notifySafely();
      print("Success add text ");
    }).catchError((error) {
      print("Error at add text => ${error.toString()}");
    });
  }

  void onTapCancel() {
    chosenFile = null;
    _notifySafely();
  }

  void onTapMoreButton() {
    isPopUp = !isPopUp;
    _notifySafely();
  }

  void onTapTextField() {
    isPopUp = false;
    _notifySafely();
  }

  void onChosenFile(File? file, String fileType) {
    print("File type => $fileType");
    chosenFile = file;
    chosenFileType = fileType;
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
