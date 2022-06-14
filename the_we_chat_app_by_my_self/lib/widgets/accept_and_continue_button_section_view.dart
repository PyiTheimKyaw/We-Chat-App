import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/pages/privacy_policy_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';

class AcceptAndContinueButtonSectionView extends StatelessWidget {
  const AcceptAndContinueButtonSectionView({
    Key? key,
    required this.onPressed,
    required this.buttonColor,
    required this.buttonTextColor,
  }) : super(key: key);
  final Function onPressed;
  final Color buttonColor;
  final Color buttonTextColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: MARGIN_LARGE),
      child: MaterialButton(
        height: MOMENT_USER_PROFILE_HEIGHT,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MARGIN_SMALL),
        ),
        color: buttonColor,
        onPressed: () {
          onPressed();
        },
        child: Text(
          LABEL_ACCOUNT_AUTHENTICATION_BUTTON,
          style: TextStyle(
              color: buttonTextColor,
        ),
      ),
      ),
    );
  }
}
