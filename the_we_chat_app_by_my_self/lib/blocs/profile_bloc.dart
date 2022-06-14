import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class ProfileBloc extends ChangeNotifier{
  ///Model
  AuthenticationModel mModel=AuthenticationModelImpl();


  UserVO? loggedInUser;
  ProfileBloc(){
    loggedInUser=mModel.getLoggedInUser();
  }
  Future onTapSignOut(){
   return mModel.logOut();
  }
}