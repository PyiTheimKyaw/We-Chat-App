import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/profile_bloc.dart';
import 'package:the_we_chat_app_by_my_self/pages/qr_code_view_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/welcome_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/card_item_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/profile_image_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ProfileBloc(),
      child: Consumer<ProfileBloc>(
        builder: (BuildContext context, bloc, Widget? child) {
          return Container(
            color: BACKGROUND_COLOR,
            child: ListView(
              children: [
                ProfileSectionView(
                  userName: bloc.loggedInUser?.userName ?? "",
                  profilePicture: bloc.loggedInUser?.profilePicture ?? "",
                  onTapQrCode: () {
                    navigateToNextScreen(
                        context,
                        QRCodeViewPage(
                          loggedInUser: bloc.loggedInUser,
                        ));
                  },
                  onTapProfile: () {
                    _showBottomSheet(context, onTapView: () {},
                        onTapChange: () async {
                      ImagePicker picker = ImagePicker();
                      XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        bloc.onChangeProfile(File(image.path));
                      }
                    });
                  },
                ),
                const UserFunctionSectionView(),
                const LogOutButtonSectionView(),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showBottomSheet(BuildContext context,
      {required Function onTapView, required Function onTapChange}) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(MARGIN_MEDIUM_2),
        topRight: Radius.circular(MARGIN_MEDIUM_2),
      )),
      context: context,
      builder: (BuildContext context) => Container(
        height: MediaQuery.of(context).size.height / 7,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(MARGIN_MEDIUM_2),
            topRight: Radius.circular(MARGIN_MEDIUM_2),
          ),
          color: Colors.white,
        ),
        child: Center(
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  onTapView();
                },
                leading: const Icon(Icons.photo_size_select_actual_outlined),
                title: const Text("View profile picture"),
              ),
              ListTile(
                onTap: () {
                  onTapChange();
                },
                leading: const Icon(Icons.add_a_photo_outlined),
                title: const Text("Edit profile picture"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LogOutButtonSectionView extends StatelessWidget {
  const LogOutButtonSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return Center(
          child: GestureDetector(
            onTap: () {
              bloc.onTapSignOut().then((value) {
                navigateToNextScreen(context, const WelcomePage());
              });
            },
            child: Container(
              margin: const EdgeInsets.only(top: MARGIN_LARGE),
              width: 200,
              height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  border: Border.all(width: 1, color: Colors.black26)
                  // boxShadow: const [
                  //   BoxShadow(
                  //     color: Colors.grey,
                  //     offset: Offset(0.0, 1.0), //(x,y)
                  //     blurRadius: 3.0,
                  //   ),
                  // ],
                  ),
              child: const Center(child: Text("Log Out")),
            ),
          ),
        );
      },
    );
  }
}

class UserFunctionSectionView extends StatelessWidget {
  const UserFunctionSectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> cardLabelInfo = [
      "Photos",
      "Favourites",
      "Wallet",
      "Cards",
      "Stickers",
      "Settings"
    ];

    List<IconData> cardIconLabel = [
      Icons.photo_outlined,
      Icons.favorite_border,
      Icons.wallet_travel_outlined,
      Icons.credit_card_outlined,
      Icons.emoji_emotions_outlined,
      Icons.settings_outlined,
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: MARGIN_LARGE * 2),
          child: Text(
            "The worst of all possible universe and the best of all possible earth",
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: MARGIN_LARGE,
        ),
        CardsSectionView(cardLabelInfo: cardLabelInfo, cardIcon: cardIconLabel),
      ],
    );
  }
}

class CardsSectionView extends StatelessWidget {
  const CardsSectionView({
    Key? key,
    required this.cardLabelInfo,
    required this.cardIcon,
  }) : super(key: key);

  final List<String> cardLabelInfo;
  final List<IconData> cardIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: null,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 3.0), //(x,y)
            blurRadius: 5.0,
          ),
        ],
        color: Colors.white,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 6,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return CardItemView(
            label: cardLabelInfo[index],
            icon: cardIcon[index],
          );
        },
      ),
    );
  }
}

class ProfileSectionView extends StatelessWidget {
  const ProfileSectionView({
    Key? key,
    required this.userName,
    required this.profilePicture,
    required this.onTapQrCode,
    required this.onTapProfile,
  }) : super(key: key);
  final String userName;
  final String profilePicture;
  final Function onTapQrCode;
  final Function onTapProfile;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: PROFILE_HEIGHT * 1.2),
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 4,
          color: PRIMARY_COLOR,
          child: Padding(
            padding: const EdgeInsets.only(
              bottom: PROFILE_HEIGHT,
              // left: MediaQuery.of(context).size.width/3
            ),
            child: GestureDetector(
              onTap: () {
                onTapQrCode();
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Container()),
                  Expanded(flex: 3, child: TitleText(title: userName)),
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        Icon(
                          Icons.qr_code_outlined,
                          color: Colors.white,
                        ),
                        Icon(
                          Icons.chevron_right_outlined,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 4 - PROFILE_HEIGHT,
          child: GestureDetector(
            onTap: () {
              onTapProfile();
            },
            child: Container(
              width: 170,
              height: 170,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                  child: ProfileImageView(
                profilePicture: profilePicture,
                radius: PROFILE_HEIGHT,
              )),
            ),
          ),
        )
      ],
    );
  }
}
