import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/chat_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/dummy_data/messages.dart';

class ChatDetailsPageBloc extends ChangeNotifier {
  bool isPopUp = false;
  bool isDisposed = false;
  File? chosenFile;
  String? chosenFileType;
  List<ChatMessageVO>? conversations;

  ChatDetailsPageBloc(){
    conversations=messages;
    _notifySafely();
  }

  void onTapCancel(){
    chosenFile=null;
    _notifySafely();
  }

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
