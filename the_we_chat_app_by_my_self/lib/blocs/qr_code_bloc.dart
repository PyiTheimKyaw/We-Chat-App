import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model.dart';
import 'package:the_we_chat_app_by_my_self/data/models/we_chat_model_impl.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class QRCodeBloc extends ChangeNotifier {
  String? qrCode;
  bool isDisposed = false;
  UserVO? scannedUser;

  ///Model
  WeChatModel mWeChatModel = WeChatModelImpl();

  // QRCodeBloc(){
  //   if(qrCode!=null){
  //
  //   }
  // }

  Future scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          "#5fa693", "Cancel", true, ScanMode.QR);
      this.qrCode = qrCode;
      _notifySafely();
      mWeChatModel.getUserByQRCode(qrCode ?? "").listen((userByQR) {
        print("QR => $qrCode Name => ${userByQR.userName}");
        scannedUser = userByQR;
        _notifySafely();
      });
    } on PlatformException {
      qrCode = "Failed";
      _notifySafely();
    }
  }



  Future<void> addAnotherContact() {
    return mWeChatModel.addAnotherUserContact(scannedUser!);
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
