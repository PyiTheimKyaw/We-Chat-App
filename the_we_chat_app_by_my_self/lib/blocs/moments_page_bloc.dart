import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class MomentsPageBloc extends ChangeNotifier {
  File? chosenCoverImage;
  bool isDisposed = false;
  String? commentText;

  ///States
  List<MomentVO>? momentsList;
  UserVO? loggedInUser;

  ///Models
  WeChatModel mWeChatModel = WeChatModelImpl();
  AuthenticationModel mAuthModel = AuthenticationModelImpl();

  MomentsPageBloc() {
    momentsList = null;
    _notifySafely();
    loggedInUser = mAuthModel.getLoggedInUser();
    mWeChatModel.getUserByQRCode(loggedInUser?.id ?? "").listen((user) {
      loggedInUser = user;
      _notifySafely();
    });
    mWeChatModel.getMoments().listen((moments) {
      print("Moments list => ${moments.length}");
      momentsList = moments;
      _notifySafely();
      moments.forEach((element) {
        mWeChatModel.getComments(element.id ?? 0).listen((event) {
          element.comments = event;
          _notifySafely();
          print(("Comments  List length => ${momentsList?.length}"));
        });
      });
    });
  }

  void onTapDelete(int momentId) {
    mWeChatModel.deleteMoment(momentId);
  }

  void onChosenCoverImage(File imageFile) {
    chosenCoverImage = imageFile;
    mAuthModel.changeCoverPicture(loggedInUser ?? UserVO(), imageFile);
    _notifySafely();
  }

  void _notifySafely() {
    if (!isDisposed) {
      notifyListeners();
    }
  }

  void onChangeComment(String comment) {
    commentText = comment;
    _notifySafely();
  }

  Future onTapSendComment(int momentId) {
    if (commentText != "") {
      return mWeChatModel.addComment(
          loggedInUser?.userName ?? "", momentId, commentText ?? "");
    }
    return Future.value();
  }

  @override
  void dispose() {
    super.dispose();
    isDisposed = true;
  }
}
