
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class QRCodeBloc extends ChangeNotifier{
  String? qrCode;
  bool isDisposed = false;

  Future<void> scanQR() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
          "#5fa693", "Cancel", true, ScanMode.QR);
        this.qrCode = qrCode;
        _notifySafely();
    } on PlatformException {
      qrCode = "Failed";
      _notifySafely();
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

  }
}