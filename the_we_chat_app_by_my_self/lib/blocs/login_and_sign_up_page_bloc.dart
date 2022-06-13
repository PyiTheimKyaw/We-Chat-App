import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginAndSignUpPageBloc extends ChangeNotifier {
  bool isDisposed = false;
  File? chosenProfileImage;
  int val = -1;
  bool canAcceptAndContinue = false;
  bool isSecure=true;

  ///Text fields values
  String? userName;
  String? phoneNumber;
  String? email;
  String? password;

  ///Country code
  Country selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('95');

  LoginAndSignUpPageBloc() {
    userName = "";
    phoneNumber = "";
    email = "";
    password = "";
  }

  void onTapLogin() {
    print("Tapped log in");
  }

  void onTapSignUp() {
    print("Tapped sign up");
  }

  void onTextChangedName(String name) {
    userName = name;
    _notifySafely();
  }

  void onTextChangedPhoneNumber(String phNumber) {
    phoneNumber = "+${selectedDialogCountry.phoneCode}$phNumber";
    _notifySafely();
    print("phone code => $phoneNumber");
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
  void onTapUnsecure(){
    isSecure=!isSecure;
    _notifySafely();
  }
  void selectRadio(value) {
    print('radio value => $value');
    if (value == 1) {
      val = value;
      _notifySafely();
    } else {
      val = -1;
      _notifySafely();
    }
  }

  bool canCreateAccount() {
    if (val == 1 &&
        userName != "" &&
        phoneNumber != "" &&
        email != "" &&
        password != "") {
      return true;
    } else {
      return false;
    }
  }

  bool canLoginAccount() {
    if (email != "" && password != "") {
      return true;
    } else {
      return false;
    }
  }

  void onChosenProfileImage(File image) {
    chosenProfileImage = image;
    _notifySafely();
  }

  void onChosenCountry(Country country) {
    selectedDialogCountry = country;
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
