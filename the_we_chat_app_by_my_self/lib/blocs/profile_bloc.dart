import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class ProfileBloc extends ChangeNotifier {
  ///Model
  AuthenticationModel mModel = AuthenticationModelImpl();
  FirebaseAuth auth = FirebaseAuth.instance;
  WeChatModel mWeChatModel = WeChatModelImpl();
  UserVO? loggedInUser;
  bool isDisposed = false;

  ProfileBloc() {
    loggedInUser = mModel.getLoggedInUser();
    _notifySafely();
  }

  Future onTapSignOut() {
    return mModel.logOut();
  }

  void onChangeProfile(File image) {
    mModel.changeProfilePicture(loggedInUser ?? UserVO(), image);
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
