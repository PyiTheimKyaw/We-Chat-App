import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:the_we_chat_app_by_my_self/blocs/qr_code_bloc.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/pages/start_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
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
                bloc.scanQR().whenComplete(() {
                  (bloc.qrCode != '-1')
                      ? Future.delayed(const Duration(seconds: 3))
                          .then((value) {
                          (bloc.scannedUser != null)
                              ? _showDialog(context,
                                  scannedUser: bloc.scannedUser, onTapOk: () {
                                  bloc.addAnotherContact().then((value) {
                                    navigateToNextScreen(
                                        context,
                                        StartPage(
                                          index: 1,
                                        ));
                                  }).catchError((error) {
                                    showSnackBarWithMessage(
                                        context, error.toString());
                                  });
                                }, onTapCancel: () {
                                  Navigator.pop(context);
                                })
                              : showSnackBarWithMessage(
                                  context, "You Should scan a correct contact");
                        })
                      : null;

                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>QRScannerPage()));
                });
                // navigateToNextScreen(context, const QRScannerPage());
              },
              child: const Icon(Icons.camera_alt_outlined),
            ),
            appBar: AppBar(
              automaticallyImplyLeading: false,
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
      {required UserVO? scannedUser,
      required Function() onTapOk,
      required Function() onTapCancel}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Are you sure to add this contact?"),
        content: ListTile(
          leading: ProfileImageView(
              profilePicture: scannedUser?.profilePicture ?? ""),
          title: Text(scannedUser?.userName ?? ""),
        ),
        actions: [
          FlatButton(onPressed: onTapCancel, child: const Text("Cancel")),
          FlatButton(onPressed: onTapOk, child: const Text("Ok")),
        ],
      ),
    );
  }
}
