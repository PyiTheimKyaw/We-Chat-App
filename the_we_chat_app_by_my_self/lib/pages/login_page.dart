import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/login_bloc.dart';
import 'package:the_we_chat_app_by_my_self/pages/start_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/welcome_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/loading_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/text_field_view.dart';
import 'package:the_we_chat_app_by_my_self/widgets/accept_and_continue_button_section_view.dart';
import 'package:the_we_chat_app_by_my_self/widgets/title_section_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => LoginBloc(),
      child: Selector<LoginBloc, bool>(
        selector: (BuildContext context, bloc) => bloc.isLoading,
        shouldRebuild: (previous, next) => previous != next,
        builder: (BuildContext context, isLoading, Widget? child) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () {
                      navigateToNextScreen(context, const WelcomePage());
                    },
                    icon: const Icon(
                      Icons.close_outlined,
                      color: Colors.black,
                    ),
                  ),
                ),
                body: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.symmetric(
                      horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_XLARGE),
                  width: double.infinity,
                  color: Colors.white,
                  child: Consumer<LoginBloc>(
                    builder: (BuildContext context, bloc, Widget? child) {
                      return Column(
                        children: [
                          const TitleSectionView(
                            title: LOGIN_VIA_EMAIL,
                          ),
                          const SizedBox(
                            height: MARGIN_XLARGE * 2,
                          ),
                          TextFieldView(
                            hintText: "Enter your email",
                            prefixText: PREFIX_EMAIL,
                            onChanged: (email) {
                              bloc.onTextChangedEmail(email);
                            },
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          TextFieldView(
                            hintText: "Enter your password",
                            isPassword: true,
                            prefixText: PREFIX_PASSWORD,
                            onChanged: (password) {
                              bloc.onTextChangedPassword(password);
                            },
                            onTapUnSecure: () {
                              bloc.onTapUnsecure();
                            },
                            isUnsecure: bloc.isSecure,
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          const Spacer(),
                          const Text(
                            "The above email is only used for login verification",
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(
                            height: MARGIN_MEDIUM_2,
                          ),
                          AcceptAndContinueButtonSectionView(
                            onPressed: () {
                              if (bloc.canLoginAccount()) {
                                bloc.onTapLogin().then((value) {
                                  navigateToNextScreen(
                                      context, const StartPage());
                                }).catchError((error) {
                                  showSnackBarWithMessage(
                                      context, error.toString());
                                });
                              } else {
                                showSnackBarWithMessage(context,
                                    "Please check your data to log in");
                              }
                            },
                            buttonColor: (bloc.canLoginAccount())
                                ? BUTTON_COLOR
                                : BACKGROUND_COLOR,
                            buttonTextColor: (bloc.canLoginAccount())
                                ? Colors.white
                                : Colors.black12,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
              Visibility(
                  visible: isLoading,
                  child: const Align(
                      alignment: Alignment.center, child: LoadingView())),
            ],
          );
        },
      ),
    );
  }
}
