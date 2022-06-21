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
  List<String> reactedUser=[];
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
        mWeChatModel.getAllReacts(element.id ?? 0).listen((fav) {
          mWeChatModel.getComments(element.id ?? 0).listen((event) {
            reactedUser.clear();
            _notifySafely();
            fav.map((item) {
              if (item.id == mAuthModel.getLoggedInUser().id) {
                reactedUser.add(item.userName ?? "");
                _notifySafely();
                element.isReacted = true;

                _notifySafely();
              }
            }).toList();
            element.favourites = fav;
            _notifySafely();
            element.comments = event;
            _notifySafely();
            print(("Comments  List length => ${momentsList?.length}"));
          });
        });
      });
    });
  }

  void onTapReact(int momentId, int momentIndex) {
    print("why");

    if (momentsList?.elementAt(momentIndex).isReacted ?? false) {
      mWeChatModel.unReact(momentId).then((value) {
        momentsList?[momentIndex].isReacted = false;
        momentsList = momentsList;
        _notifySafely();
      });
    } else {
      mWeChatModel.reactMoment(momentId);
      _notifySafely();
    }
    // mWeChatModel.getAllReacts(momentId).listen((fav) {
    //   fav.map((e) {
    //     print("Fav id ${e.id}");
    //     if (e.id == mAuthModel.getLoggedInUser().id) {
    //       print("un react");
    //       mWeChatModel.unReact(momentId).then((value) {
    //         momentsList?[momentIndex].isReacted = false;
    //         momentsList = momentsList;
    //         _notifySafely();
    //       });
    //     } else if(e.id != mAuthModel.getLoggedInUser().id) {
    //       print("react");
    //       mWeChatModel.reactMoment(momentId);
    //       _notifySafely();
    //     }
    //   }).toList();
    // });
    // mWeChatModel.unReact(momentId);
    // mWeChatModel.reactMoment(momentId);
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
