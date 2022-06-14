import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:the_we_chat_app_by_my_self/blocs/qr_code_bloc.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/view_items/profile_image_view.dart';

class QRCodeViewPage extends StatelessWidget {
  QRCodeViewPage({Key? key, required this.loggedInUser}) : super(key: key);
  UserVO? loggedInUser;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => QRCodeBloc(),
      child: Consumer<QRCodeBloc>(
        builder: (BuildContext context, bloc, Widget? child) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: PRIMARY_COLOR,
              onPressed: () {
                bloc.scanQR().then((value) {
                  print("Success");
                  (bloc.qrCode != '-1')
                      ? _showDialog(context, onTapOk: () {}, onTapCancel: () {
                          Navigator.pop(context);
                        })
                      : null;
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>QRScannerPage()));
                });
                // navigateToNextScreen(context, const QRScannerPage());
              },
              child: const Icon(Icons.camera_alt_outlined),
            ),
            appBar: AppBar(
              backgroundColor: PRIMARY_COLOR,
              elevation: 0,
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  )),
            ),
            body: Container(
              color: BACKGROUND_COLOR,
              child: Center(
                child: QrImage(
                  data: loggedInUser?.qrCode ?? "",
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDialog(BuildContext context,
      {required Function() onTapOk, required Function() onTapCancel}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure to add this contact?"),
        content: const ListTile(
          leading: ProfileImageView(profilePicture: ""),
          title: Text("Pyi Theim Kyaw"),
        ),
        actions: [
          FlatButton(onPressed: onTapCancel, child: const Text("Cancel")),
          FlatButton(onPressed: onTapOk, child: const Text("Ok")),
        ],
      ),
    );
  }
}
