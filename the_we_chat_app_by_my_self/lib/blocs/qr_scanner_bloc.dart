import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';

class QRScannerBloc extends ChangeNotifier {
  bool isScannedCompleted = false;
  bool isDisposed = false;
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  
  
  QRScannerBloc(){
    if(result!=null){
      print("Result has data");
    }else{
      print("result is null");
    }
    controller?.resumeCamera();
    _notifySafely();
  }

  Stream onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    this.controller?.resumeCamera();
    _notifySafely();

    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      isScannedCompleted = true;
      controller.pauseCamera();
      _notifySafely();
      print("Result => ${result?.code}");
    });
    return Stream.value(controller);
  }

  Future<QRViewController> onTapFlipCamera() {
    controller?.flipCamera();
    _notifySafely();
    return Future.value(controller);
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
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
    controller?.dispose();
  }
}
