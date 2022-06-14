import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:the_we_chat_app_by_my_self/blocs/qr_scanner_bloc.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => QRScannerBloc(),
      child: Consumer<QRScannerBloc>(
        builder: (BuildContext context, bloc, Widget? child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                await bloc.onTapFlipCamera();
              },
              child: const Icon(Icons.camera_front),
            ),
            body: Column(
              children: [
                Expanded(flex: 4, child: _buildQrView(context)),
                Visibility(
                    visible: (bloc.isScannedCompleted), child: Text("OK")),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Consumer<QRScannerBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return QRView(
          key: bloc.qrKey,
          onQRViewCreated: (controller) {
            bloc.onQRViewCreated(controller).whenComplete(() {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content: const Text("Are you sure to add this contact"),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Ok")),
                    ],
                  ));
            });
          },
          overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => bloc.onPermissionSet(context, ctrl, p),
        );
      },
    );
  }
}
