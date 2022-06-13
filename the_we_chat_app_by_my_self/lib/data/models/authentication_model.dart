import 'dart:io';

abstract class AuthenticationModel{
  Future<void> register(String email,String password,String phoneNumber,File? profileImage);
  Future<void> login(String email,String password);
  bool isLoggedIn();
}