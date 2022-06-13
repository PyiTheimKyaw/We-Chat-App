import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/login_and_sign_up_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/pages/add_moment_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginAndSignUpPageBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              color: Colors.black,
            ),
          ),
        ),
        body: Consumer<LoginAndSignUpPageBloc>(
          builder: (BuildContext context, bloc, Widget? child) {
            return Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: MARGIN_XLARGE, vertical: MARGIN_XLARGE),
              color: Colors.white,
              height: double.infinity,
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TitleSectionView(),
                  const SizedBox(
                    height: MARGIN_XLARGE,
                  ),
                  EmailVerificationSectionView(
                    onChangeEmail: (email) {
                      bloc.onTextChangedEmail(email);
                    },
                  ),
                  VerifiedButtonView(
                    onTapVerified: () {
                      if (bloc.email != "") {
                        print("Email has data");
                      } else {
                        showSnackBarWithMessage(
                            context, "Please input your email!");
                      }
                    },
                    email: bloc.email,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class VerifiedButtonView extends StatelessWidget {
  const VerifiedButtonView(
      {Key? key, required this.onTapVerified, required this.email})
      : super(key: key);
  final Function onTapVerified;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: BUTTON_WIDTH,
      color: (email != "") ? BUTTON_COLOR : BACKGROUND_COLOR,
      onPressed: () {
        onTapVerified();
      },
      child: const Text(
        "OK",
        style: TextStyle(color: Colors.white, fontSize: TEXT_REGULAR),
      ),
    );
  }
}

class EmailVerificationSectionView extends StatelessWidget {
  const EmailVerificationSectionView({
    Key? key,
    required this.onChangeEmail,
  }) : super(key: key);
  final Function(String) onChangeEmail;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        alignment: Alignment.topLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Enter verification information",
              style: TextStyle(color: Colors.black38),
            ),
            const Divider(
              thickness: 1,
            ),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                hintText: "Enter email address",
                prefixIcon: Text(
                  PREFIX_EMAIL,
                  style: TextStyle(fontSize: MARGIN_MEDIUM_2),
                ),
                prefixIconConstraints:
                    BoxConstraints(minWidth: 100, minHeight: 0),
              ),
              onChanged: (email) {
                onChangeEmail(email);
              },
            ),
            const Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class TitleSectionView extends StatelessWidget {
  const TitleSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      LABEL_EMAIL_VERIFICATION,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: TEXT_LARGE - TEXT_SMALL),
    );
  }
}
