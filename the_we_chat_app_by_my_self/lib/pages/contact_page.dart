import 'package:azlistview/azlistview.dart';
import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/contact_bloc.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/az_item_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/pages/chat_detail_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/card_item_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/profile_image_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ContactTabBloc(),
      child: Scaffold(
          // resizeToAvoidBottomInset: false,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: PRIMARY_COLOR,
            centerTitle: true,
            title: TitleText(title: LABEL_CONTACTS),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add_alt_1_outlined),
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<ContactTabBloc>(
                builder: (BuildContext context, bloc, Widget? child) {
                  return SearBarSectionView(
                    onChanged: (text) {
                      bloc.searchByName(text);
                    },
                  );
                },
              ),
              const ContactsCardsSectionView(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: MARGIN_SMALL),
                  color: Colors.white,
                  child: Consumer<ContactTabBloc>(
                    builder: (BuildContext context, bloc, Widget? child) {
                      return(bloc.filterList?.length == 0) ? EmptyWidget(
                        hideBackgroundAnimation: true,
                        image: "images/add_friend.jpg",
                        title: "Add your besties ",
                        titleTextStyle: const TextStyle(
                            fontSize: TEXT_REGULAR, color: Colors.black45),
                      ) : Stack(
                        children: [
                          ContactSection(
                              user: bloc.filterList ?? [],
                              onClick: (user) {
                                navigateToNextScreen(
                                    context,
                                    ChatDetailPage(
                                      chatUser: user,
                                    ));
                              }),
                          Align(
                            alignment: Alignment.topRight,
                            child: FriendsCountSectionView(
                                friendCount: bloc.usersDummy?.length ?? 0),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class ContactSection extends StatelessWidget {
  final List<AZItemVO> user;
  final Function(UserVO) onClick;

  const ContactSection({
    Key? key,
    required this.user,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AzListView(
        data: user,
        itemCount: user.length,
        indexBarMargin: const EdgeInsets.only(right: MARGIN_MEDIUM),
        itemBuilder: (BuildContext context, int index) {
          final tag = user[index].getSuspensionTag();
          final length = user[index].getSuspensionTag().length;
          final offStage = !user[index].isShowSuspension;
          return ContactPeopleShowView(
            user: user,
            index: index,
            tag: tag,
            offStage: offStage,
            onClick: () {
              onClick(user[index].person);
            },
            length: length,
          );
        });
  }
}

class ContactPeopleShowView extends StatelessWidget {
  const ContactPeopleShowView({
    Key? key,
    required this.user,
    required this.index,
    required this.tag,
    required this.offStage,
    required this.onClick,
    required this.length,
  }) : super(key: key);

  final List<AZItemVO> user;
  final int index;
  final String tag;
  final bool offStage;
  final Function onClick;
  final int length;

  @override
  Widget build(BuildContext context) {
    double? indent = MediaQuery.of(context).size.width / 5;
    double? endIndent = MediaQuery.of(context).size.width / 9;
    return GestureDetector(
      onTap: () {
        onClick();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Offstage(
            offstage: offStage,
            child: Container(
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              height: MOMENT_USER_PROFILE_HEIGHT,
              color: BACKGROUND_COLOR,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MOMENT_USER_PROFILE_HEIGHT),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Color(0xFF757575),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: MARGIN_MEDIUM),
            child: Column(
              children: [
                ListTile(
                  leading: ProfileImageView(
                      radius: MARGIN_XLARGE - MARGIN_MEDIUM_2,
                      profilePicture: user[index].person.profilePicture ?? ""),
                  title: Text(
                    user[index].person.userName ?? "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Divider(
                  thickness: 1,
                  indent: indent,
                  endIndent: endIndent,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class FriendsCountSectionView extends StatelessWidget {
  FriendsCountSectionView({
    Key? key,
    required this.friendCount,
  }) : super(key: key);
  int friendCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: MARGIN_MEDIUM_2, right: MARGIN_MEDIUM_2),
      child: Text(
        (friendCount > 1) ? "$friendCount Friends" : "$friendCount Friend",
        style: TextStyle(
            color: Colors.black.withOpacity(0.5), fontSize: MARGIN_MEDIUM_2),
      ),
    );
  }
}

class ContactsCardsSectionView extends StatelessWidget {
  const ContactsCardsSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> itemLabel = [
      'New Friends',
      'Group Chats',
      'Tags',
      'Official Accounts'
    ];
    List<IconData> itemIcon = [
      Icons.person_add_alt,
      Icons.group_outlined,
      Icons.tag_outlined,
      Icons.account_box_outlined
    ];
    return Container(
      height: null,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, 3.0),
            blurRadius: 3.0,
          )
        ],
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: 4,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (BuildContext context, int index) {
          return CardItemView(label: itemLabel[index], icon: itemIcon[index]);
        },
      ),
    );
  }
}

class SearBarSectionView extends StatelessWidget {
  const SearBarSectionView({
    Key? key,
    required this.onChanged,
  }) : super(key: key);
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM),
      width: double.infinity,
      height: TAG_HEIGHT,
      decoration: BoxDecoration(
        color: SEARCH_BAR_COLOR,
        borderRadius: BorderRadius.circular(MARGIN_SMALL),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, offset: Offset(0.0, 2.0), blurRadius: 3.0)
        ],
      ),
      child: TextField(
        onChanged: (text) {
          onChanged(text);
        },
        textAlign: TextAlign.center,
        maxLines: 1,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
        ),
      ),
    );
  }
}
