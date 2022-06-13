
import 'package:flutter/foundation.dart';

class PrivacyPageBloc extends ChangeNotifier{
  int val=-1;
  bool isDisposed=false;
  void acceptPolicy(value){
    if(value==1) {
      val = value;
      _notifySafely();
    }else{
      val=-1;
      _notifySafely();
    }
  }

  void _notifySafely(){
    if(!isDisposed){
      notifyListeners();
    }
  }

  @override
  void dispose(){
    super.dispose();
    isDisposed=true;
  }
}