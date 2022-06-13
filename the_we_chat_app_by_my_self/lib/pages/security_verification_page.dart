import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/pages/email_verification_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';

class SecurityVerificationPage extends StatelessWidget {
  const SecurityVerificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
      body: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: MARGIN_XLARGE, vertical: MARGIN_XLARGE),
        color: Colors.white,
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.info,
              color: Colors.blue,
              size: TEXT_LARGE + TEXT_MEDIUM,
            ),
            const SizedBox(
              height: MARGIN_LARGE,
            ),
            const Text(
              LABEL_SECURITY_VERIFICATION,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: TEXT_LARGE - TEXT_SMALL),
            ),
            const SizedBox(
              height: MARGIN_LARGE,
            ),
            const Text(
              'For the security on your account, verify security verification code before registration',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: TEXT_MEDIUM - TEXT_SMALL),
            ),
            const Spacer(),
            MaterialButton(
              minWidth: BUTTON_WIDTH,
              color: BUTTON_COLOR,
              onPressed: () {
                navigateToNextScreen(context, const EmailVerificationPage());
              },
              child: const Text(
                "Start",
                style: TextStyle(color: Colors.white, fontSize: TEXT_REGULAR),
              ),
            )
          ],
        ),
      ),
    );
  }
}
