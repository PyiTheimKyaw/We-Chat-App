import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/login_and_sign_up_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/pages/privacy_policy_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/bottom_sheet_option_view.dart';

class LoginAndSignUpPage extends StatelessWidget {
  const LoginAndSignUpPage({Key? key, this.isLogin = false}) : super(key: key);

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginAndSignUpPageBloc(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close_outlined,
              color: Colors.black,
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          width: double.infinity,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleSectionView(
                  title: (isLogin) ? LOGIN_VIA_EMAIL : SIGN_UP_VIA_EMAIL,
                ),
                const SizedBox(
                  height: MARGIN_MEDIUM_2,
                ),
                Visibility(
                  visible: !isLogin,
                  child: const ChooseProfilePictureSectionView(),
                ),
                const SizedBox(
                  height: MARGIN_XLARGE,
                ),
                TextFieldsSectionView(isLogin: isLogin),
                const SizedBox(
                  height: MARGIN_XLARGE,
                ),
                Visibility(
                    visible: !isLogin,
                    child: const TermsAndServiceSectionView()),
                SizedBox(
                  height: (isLogin) ? MARGIN_XLARGE * 10 : MARGIN_XLARGE,
                ),
                AcceptAndContinueButtonSectionView(
                  isLogin: isLogin,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AcceptAndContinueButtonSectionView extends StatelessWidget {
  const AcceptAndContinueButtonSectionView({
    Key? key,
    required this.isLogin,
  }) : super(key: key);
  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginAndSignUpPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: MARGIN_LARGE),
          child: MaterialButton(
            height: MOMENT_USER_PROFILE_HEIGHT,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(MARGIN_SMALL),
            ),
            color: (isLogin)
                ? (bloc.canLoginAccount())
                    ? BUTTON_COLOR
                    : BACKGROUND_COLOR
                : (bloc.canCreateAccount())
                    ? BUTTON_COLOR
                    : BACKGROUND_COLOR,
            onPressed: () {
              if (isLogin) {
                if (bloc.canLoginAccount()) {
                  bloc.onTapLogin();
                } else {
                  showSnackBarWithMessage(
                      context, "Please check your data to log in");
                }
              } else {
                if (bloc.canCreateAccount()) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicyPage(
                              mdFileName: 'privacy_policy.md')));
                  bloc.onTapSignUp();
                } else {
                  showSnackBarWithMessage(
                      context, "Please fill all Fields and accept Privacy");
                }
              }
            },
            child: Text(
              LABEL_ACCOUNT_AUTHENTICATION_BUTTON,
              style: TextStyle(
                  color: (isLogin)
                      ? (bloc.canLoginAccount())
                          ? Colors.white
                          : Colors.black12
                      : (bloc.canCreateAccount())
                          ? Colors.white
                          : Colors.black12),
            ),
          ),
        );
      },
    );
  }
}

class TermsAndServiceSectionView extends StatelessWidget {
  const TermsAndServiceSectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginAndSignUpPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Radio(
                    fillColor: MaterialStateColor.resolveWith(
                        (states) => BUTTON_COLOR),
                    value: 1,
                    groupValue: bloc.val,
                    toggleable: true,
                    onChanged: (value) {
                      bloc.selectRadio(value);
                    }),
                Expanded(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "I have read and accept the ",
                          style: TextStyle(color: Colors.black54),
                        ),
                        TextSpan(
                          text: "<<Terms of Service>>",
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print("Text span tapped");
                              // Single tapped.
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Text(
              "The information collected on this page is only used for account registration",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            )
          ],
        );
      },
    );
  }
}

class TextFieldsSectionView extends StatelessWidget {
  const TextFieldsSectionView({
    Key? key,
    required this.isLogin,
  }) : super(key: key);

  final bool isLogin;

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginAndSignUpPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return Column(
          children: [
            Visibility(
                visible: !isLogin,
                child: SignUpRequirementsView(
                  inputName: (name) {
                    bloc.onTextChangedName(name);
                  },
                  inputPhone: (phoneNumber) {
                    bloc.onTextChangedPhoneNumber(phoneNumber);
                  },
                )),
            Visibility(
              visible: isLogin,
              child: TextFieldView(
                hintText: "Enter your email",
                prefixText: PREFIX_EMAIL,
                onChanged: (email) {
                  bloc.onTextChangedEmail(email);
                },
              ),
            ),
            Visibility(
                visible: isLogin,
                child: const Divider(
                  thickness: 1,
                )),
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
          ],
        );
      },
    );
  }
}

class SignUpRequirementsView extends StatelessWidget {
  SignUpRequirementsView({required this.inputName, required this.inputPhone});

  final Function(String) inputName;
  final Function(String) inputPhone;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldView(
          hintText: "John Appleseed",
          prefixText: PERFIX_NAME,
          onChanged: inputName,
        ),
        const Divider(
          thickness: 1,
        ),
        const SizedBox(
          height: MARGIN_MEDIUM,
        ),
        Consumer<LoginAndSignUpPageBloc>(
          builder: (BuildContext context, bloc, Widget? child) {
            return GestureDetector(
                onTap: () {
                  _openCountryPickerDialog(context, (country) {
                    bloc.onChosenCountry(country);
                  });
                },
                child: _buildDialogItem(bloc.selectedDialogCountry));
          },
        ),
        const SizedBox(
          height: MARGIN_MEDIUM,
        ),
        const Divider(
          thickness: 1,
        ),
        TextFieldView(
          hintText: 'Enter mobile number',
          isPhone: true,
          prefixText: PREFIX_PHONE,
          onChanged: inputPhone,
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }

  Widget _buildDialogItem(Country country) => Row(
        children: [
          const Text(
            PREFIX_REGION,
            style: TextStyle(fontSize: MARGIN_MEDIUM_2),
          ),
          const SizedBox(
            width: MARGIN_XLARGE + MARGIN_SMALL,
          ),
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: MARGIN_SMALL),
          Flexible(child: Text(country.name)),
          const SizedBox(width: MARGIN_SMALL),
          Text("(+${country.phoneCode})"),
          const Spacer(),
          const Icon(Icons.chevron_right_outlined)
        ],
      );

  Widget _buildDialogItemForPopUp(Country country) => Row(
        children: [
          CountryPickerUtils.getDefaultFlagImage(country),
          const SizedBox(width: MARGIN_SMALL),
          Flexible(child: Text(country.name)),
          const SizedBox(width: MARGIN_SMALL),
          Text("(+${country.phoneCode})"),
        ],
      );

  void _openCountryPickerDialog(
          BuildContext context, Function(Country) onValuePicked) =>
      showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: const EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: const InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: const Text('Select your phone code'),
            onValuePicked: onValuePicked,
            itemBuilder: _buildDialogItemForPopUp,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('TR'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ],
          ),
        ),
      );
}

class TextFieldView extends StatelessWidget {
  const TextFieldView({
    Key? key,
    required this.prefixText,
    this.isPassword = false,
    this.isPhone = false,
    required this.hintText,
    required this.onChanged,
    this.onTapUnSecure,
    this.isUnsecure = false,
  }) : super(key: key);
  final String prefixText;
  final String hintText;
  final bool isPassword;
  final bool isPhone;
  final Function(String) onChanged;
  final Function? onTapUnSecure;
  final bool isUnsecure;

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: isPhone ? TextInputType.number : null,
      inputFormatters: [
        (isPhone)
            ? FilteringTextInputFormatter.digitsOnly
            : FilteringTextInputFormatter.singleLineFormatter
      ],
      obscureText: (isPassword)
          ? (isUnsecure)
              ? true
              : false
          : false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        hintText: hintText,
        isDense: true,
        prefixIcon: Text(
          prefixText,
          style: const TextStyle(fontSize: MARGIN_MEDIUM_2),
        ),
        prefixIconConstraints:
            const BoxConstraints(minWidth: 100, minHeight: 0),
        suffixIcon: Visibility(
          visible: isPassword,
          child: IconButton(
            onPressed: () {
              onTapUnSecure!();
            },
            icon: Icon(
                (isUnsecure) ? Icons.remove_red_eye_outlined : Icons.security),
          ),
        ),
      ),
      onChanged: (text) {
        onChanged(text);
      },
    );
  }
}

class ChooseProfilePictureSectionView extends StatelessWidget {
  const ChooseProfilePictureSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginAndSignUpPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return GestureDetector(
          onTap: () {
            _showModalBottomSheet(context, () async {
              Navigator.pop(context);
              ImagePicker picker = ImagePicker();
              XFile? image = await picker.pickImage(source: ImageSource.camera);
              if (image != null) {
                bloc.onChosenProfileImage(File(image.path));
              }
            }, () async {
              Navigator.pop(context);
              ImagePicker picker = ImagePicker();
              XFile? image =
                  await picker.pickImage(source: ImageSource.gallery);
              if (image != null) {
                bloc.onChosenProfileImage(File(image.path));
              }
            });
          },
          child: Container(
            height: CHATTING_SECTION_HEIGHT,
            width: CHATTING_SECTION_HEIGHT,
            decoration: const BoxDecoration(
              color: BACKGROUND_COLOR,
            ),
            child: (bloc.chosenProfileImage != null)
                ? Image.file(
                    bloc.chosenProfileImage ?? File(""),
                    fit: BoxFit.cover,
                  )
                : Image.network(
                    "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png?w=640",
                    fit: BoxFit.cover,
                  ),
          ),
        );
      },
    );
  }

  _showModalBottomSheet(BuildContext context, Function onTapTakePhoto,
      Function onTapChooseAlbum) {
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
                  label: LABEL_TAKE_PHOTO,
                  onTap: onTapTakePhoto,
                ),
                const Divider(
                  thickness: 1,
                ),
                BottomSheetOptionView(
                  label: LABEL_CHOOSE_FROM_ALBUM,
                  onTap: onTapChooseAlbum,
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

class TitleSectionView extends StatelessWidget {
  const TitleSectionView({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
          const TextStyle(fontSize: TEXT_REGULAR, fontWeight: FontWeight.w400),
    );
  }
}
