import 'dart:io';

abstract class AuthenticationModel{
  Future<void> register(String userName,String email,String password,String phoneNumber,File? profileImage);
  Future<void> login(String email,String password);
  bool isLoggedIn();
  Future<void> logOut();
}