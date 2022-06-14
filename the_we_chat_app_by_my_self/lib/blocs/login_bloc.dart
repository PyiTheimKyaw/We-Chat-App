import 'package:flutter/foundation.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/authentication_model_impl.dart';

class LoginBloc extends ChangeNotifier {
  bool isDisposed = false;
  bool isSecure = true;
  bool isLoading = false;

  String email = '';
  String password = '';

  ///Model
  AuthenticationModel mModel = AuthenticationModelImpl();

  Future onTapLogin() {
    _showLoading();
    return mModel.login(email, password).whenComplete(() => _hideLoading());
  }

  void onTextChangedEmail(String email) {
    print("Email => $email");
    this.email = email;
    _notifySafely();
  }

  void onTextChangedPassword(String password) {
    this.password = password;
    _notifySafely();
  }

  void onTapUnsecure() {
    isSecure = !isSecure;
    _notifySafely();
  }

  bool canLoginAccount() {
    if (email != "" && password != "") {
      return true;
    } else {
      return false;
    }
  }

  void _showLoading() {
    isLoading = true;
    _notifySafely();
  }

  void _hideLoading() {
    isLoading = false;
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
