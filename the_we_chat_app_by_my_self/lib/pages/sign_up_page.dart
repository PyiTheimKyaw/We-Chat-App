import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/sign_up_bloc.dart';
import 'package:the_we_chat_app_by_my_self/pages/privacy_policy_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/start_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/bottom_sheet_option_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/text_field_view.dart';
import 'package:the_we_chat_app_by_my_self/widgets/accept_and_continue_button_section_view.dart';
import 'package:the_we_chat_app_by_my_self/widgets/title_section_view.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpBloc(),
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
          padding:
          const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          width: double.infinity,
          color: Colors.white,
          child: Consumer<SignUpBloc>(
            builder: (BuildContext context, bloc, Widget? child) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const TitleSectionView(
                      title: SIGN_UP_VIA_EMAIL,
                    ),
                    const SizedBox(
                      height: MARGIN_MEDIUM_2,
                    ),
                    const ChooseProfilePictureSectionView(),
                    const SizedBox(
                      height: MARGIN_XLARGE,
                    ),
                    const TextFieldsSectionView(),
                    const SizedBox(
                      height: MARGIN_XLARGE,
                    ),
                    const TermsAndServiceSectionView(),
                    const SizedBox(
                      height: MARGIN_XLARGE,
                    ),
                    AcceptAndContinueButtonSectionView(
                        onPressed: () {
                          if (bloc.canCreateAccount()) {
                            navigateToNextScreen(
                                context,
                                PrivacyPolicyPage(
                                  mdFileName: 'privacy_policy.md',
                                  userName: bloc.userName,
                                  phoneNumber: bloc.phoneNumber,
                                  profilePic: bloc.chosenProfileImage,
                                  password: bloc.password,
                                ));
                          } else {
                            showSnackBarWithMessage(context,
                                "Please fill all Fields and accept Privacy");
                          }
                        },
                        buttonColor: (bloc.canCreateAccount())
                            ? BUTTON_COLOR
                            : BACKGROUND_COLOR,
                        buttonTextColor: (bloc.canCreateAccount())
                            ? Colors.white
                            : Colors.black12),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}



class TermsAndServiceSectionView extends StatelessWidget {
  const TermsAndServiceSectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpBloc>(
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return Column(
          children: [
            TextFieldView(
              hintText: "John Appleseed",
              prefixText: PERFIX_NAME,
              onChanged: (name) {
                bloc.onTextChangedName(name);
              },
            ),
            const Divider(
              thickness: 1,
            ),
            const SizedBox(
              height: MARGIN_MEDIUM,
            ),
            GestureDetector(
                onTap: () {
                  _openCountryPickerDialog(context, (country) {
                    bloc.onChosenCountry(country);
                  });
                },
                child: _buildDialogItem(bloc.selectedDialogCountry)),
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
              onChanged: (phoneNumber) {
                bloc.onTextChangedPhoneNumber(phoneNumber);
              },
            ),
            const Divider(
              thickness: 1,
            ),
            // TextFieldView(
            //   hintText: "Enter your email",
            //   prefixText: PREFIX_EMAIL,
            //   onChanged: (email) {
            //     bloc.onTextChangedEmail(email);
            //   },
            // ),
            // const Divider(
            //   thickness: 1,
            // ),
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

class ChooseProfilePictureSectionView extends StatelessWidget {
  const ChooseProfilePictureSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpBloc>(
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
