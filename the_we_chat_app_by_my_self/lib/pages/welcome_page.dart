import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/pages/sign_up_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/login_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/bottom_sheet_option_view.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("images/welcome_screen_background.jpg"),
            fit: BoxFit.cover),
      ),
      child: LoginAndSignUpButtonSectionView(
        onTapLogin: () {
          navigateToNextScreen(
              context,
              const LoginPage(
              ));
        },
        onTapSignUp: () {
          _showModalBottomSheet(context);
        },
      ),
    );
  }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(MARGIN_MEDIUM_2),
          topRight: Radius.circular(MARGIN_MEDIUM_2),
        )),
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height / 4.4,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MARGIN_MEDIUM_2),
              topRight: Radius.circular(MARGIN_MEDIUM_2),
            )),
            child: Column(
              children: [
                BottomSheetOptionView(
                  label: SIGN_UP_VIA_EMAIL,
                  onTap: () {
                    Navigator.pop(context);
                    navigateToNextScreen(context, const SignUpPage());
                  },
                ),
                const Divider(),
                BottomSheetOptionView(
                  label: SIGN_UP_VIA_FACEBOOK,
                  onTap: () {},
                ),
                const Divider(
                  thickness: 6,
                  color: BACKGROUND_COLOR,
                ),
                BottomSheetOptionView(
                    label: LABEL_CANCEL,
                    onTap: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          );
        });
  }
}



class LoginAndSignUpButtonSectionView extends StatelessWidget {
  const LoginAndSignUpButtonSectionView({
    Key? key,
    required this.onTapLogin,
    required this.onTapSignUp,
  }) : super(key: key);
  final Function onTapLogin;
  final Function onTapSignUp;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_LARGE),
      child: Row(
        children: [
          LoginAndSignUpButtonView(
            label: LABEL_LOGIN,
            buttonColor: PRIMARY_COLOR,
            labelColor: Colors.white,
            onTap: () {
              onTapLogin();
            },
          ),
          const Spacer(),
          LoginAndSignUpButtonView(
            label: LABEL_SIGN_UP,
            buttonColor: Colors.white,
            labelColor: PRIMARY_COLOR,
            onTap: () {
              onTapSignUp();
            },
          ),
        ],
      ),
    );
  }
}

class LoginAndSignUpButtonView extends StatelessWidget {
  const LoginAndSignUpButtonView({
    Key? key,
    required this.label,
    required this.buttonColor,
    required this.onTap,
    required this.labelColor,
  }) : super(key: key);
  final String label;
  final Color labelColor;
  final Color buttonColor;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      minWidth: 100,
      height: MARGIN_XLARGE,
      color: buttonColor,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MARGIN_SMALL)),
      onPressed: () {
        onTap();
      },
      child: Text(
        label,
        style: TextStyle(color: labelColor, fontSize: MARGIN_MEDIUM_2),
      ),
    );
  }
}
