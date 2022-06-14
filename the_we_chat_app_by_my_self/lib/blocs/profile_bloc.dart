import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model_impl.dart';

class ProfileBloc extends ChangeNotifier{
  ///Model
  AuthenticationModel mModel=AuthenticationModelImpl();

  Future onTapSignOut(){
   return mModel.logOut();
  }
}