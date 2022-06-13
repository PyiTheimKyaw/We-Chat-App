import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';

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
        onTapLogin: () {},
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
                SignUpOptionsView(
                  label: SIGN_UP_VIA_EMAIL,
                  onTap: () {},
                ),
                const Divider(),
                SignUpOptionsView(
                  label: SIGN_UP_VIA_FACEBOOK,
                  onTap: () {},
                ),
                const Divider(
                  thickness: 3,
                  color: BACKGROUND_COLOR,
                ),
                SignUpOptionsView(label: LABEL_CANCEL, onTap: () {})
              ],
            ),
          );
        });
  }
}

class SignUpOptionsView extends StatelessWidget {
  const SignUpOptionsView({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          label,
          style: const TextStyle(
              fontSize: TEXT_MEDIUM - TEXT_SMALL,
              color: Colors.black87,
              fontWeight: FontWeight.w600),
        ));
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
