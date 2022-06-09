import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';

class MomentsPageBloc extends ChangeNotifier {
  File? chosenCoverImage;
  bool isDisposed = false;

  ///States
  List<MomentVO>? momentsList;
  String momentImage =
      "https://elm.umaryland.edu/voices-and-opinions/Voices--Opinions-Content/Online-Education.jpg";

  ///Models
  WeChatModel mWeChatModel = WeChatModelImpl();

  MomentsPageBloc() {
    mWeChatModel.getMoments().listen((moments) {
      momentsList = moments;
      if (!isDisposed) {
        _notifySafely();
      }
    });
  }

  void onTapDelete(int momentId) {
    mWeChatModel.deleteMoment(momentId);
  }

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
