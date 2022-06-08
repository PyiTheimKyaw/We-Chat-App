import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/view_items/card_item_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        ProfileSectionView(),
        UserFunctionSectionView(),
        LogOutButtonSectionView(),
      ],
    );
  }
}

class LogOutButtonSectionView extends StatelessWidget {
  const LogOutButtonSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: MARGIN_LARGE),
        width: 200,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 3.0,
              ),
            ]),
        child: const Center(child: Text("Log Out")),
      ),
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
      Icons.wallet_outlined,
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
            "The worst of alll possible universe and the best of all possible earth fsdfsdfds dfdsfsdfds fdfdsfd fdsf ee er ere ",
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: MARGIN_LARGE,
        ),
        CardsSectionView(
            cardLabelInfo: cardLabelInfo, cardIconLabel: cardIconLabel),
      ],
    );
  }
}

class CardsSectionView extends StatelessWidget {
  const CardsSectionView({
    Key? key,
    required this.cardLabelInfo,
    required this.cardIconLabel,
  }) : super(key: key);

  final List<String> cardLabelInfo;
  final List<IconData> cardIconLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: null,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 10.0), //(x,y)
            blurRadius: 10.0,
          ),
        ],
        color: Colors.white,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 6,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (BuildContext context, int index) {
          return CardItemView(
            label: cardLabelInfo[index],
            icon: cardIconLabel[index],
          );
        },
      ),
    );
  }
}

class ProfileSectionView extends StatelessWidget {
  const ProfileSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: PROFILE_HEIGHT * 1.2),
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 4,
          color: PRIMARY_COLOR,
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: PROFILE_HEIGHT, left: PROFILE_HEIGHT * 1.4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: TitleText(title: "Pyi Theim Kyaw")),
                SizedBox(
                  width: MARGIN_LARGE * 2,
                ),
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
        ),
        Positioned(
          top: MediaQuery.of(context).size.height / 4 - PROFILE_HEIGHT,
          child: Container(
            width: 170,
            height: 170,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Center(
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://sm.askmen.com/t/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.1200.jpg"),
                radius: PROFILE_HEIGHT,
              ),
            ),
          ),
        )
      ],
    );
  }
}


