import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/pages/chatting_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/view_items/card_item_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/chatting_item_view.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> contacts = ['A', 'B', 'C'];
    List<Widget> a = [];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PRIMARY_COLOR,
        centerTitle: true,
        title: TitleText(title:LABEL_CONTACTS),
        actions:  [
          IconButton(icon:const Icon(Icons.person_add_alt_1_outlined),color: Colors.white, onPressed: () {  },),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return const [
            SliverToBoxAdapter(
              child: SearBarSectionView(),
            ),
            SliverToBoxAdapter(
              child: ContactsCardsSectionView(),
            ),
          ];
        },
        body: Container(
          color: BACKGROUND_COLOR,
          child: Stack(
            alignment: Alignment.centerLeft,
            clipBehavior: Clip.none,
            children: [
              const ContactsListSectionView(),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.2,
                top: MediaQuery.of(context).size.width * 0.06,
                child: const ContactPerfixSectionView(),
              ),
              const Align(
                alignment: Alignment.topRight,
                child: FriendsCountSectionView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FriendsCountSectionView extends StatelessWidget {
  const FriendsCountSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: MARGIN_LARGE * 1.2, right: MARGIN_MEDIUM_2),
      child: Text(
        "15 Friends",
        style: TextStyle(
            color: Colors.black.withOpacity(0.5), fontSize: TEXT_SMALL),
      ),
    );
  }
}

class ContactPerfixSectionView extends StatelessWidget {
  const ContactPerfixSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'A',
      style: TextStyle(
          color: Colors.black.withOpacity(0.5), fontSize: TEXT_MEDIUM),
    );
  }
}

class ContactsListSectionView extends StatelessWidget {
  const ContactsListSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: MARGIN_XLARGE * 1.5),
      height: post,
      color: Colors.white,
      child: ListView.separated(
        separatorBuilder: (context, index) => const Divider(
          thickness: 0,
          color: Colors.white,
        ),
        itemCount: 10,
        padding: const EdgeInsets.symmetric(
            horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM_2),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              onTap: () {
                navigateToNextScreen(context, const ChattingPage());
              },
              child:  ChattingItemView());
        },
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
        physics: NeverScrollableScrollPhysics(),
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM),
      width: double.infinity,
      height: 40,
      decoration: BoxDecoration(
        color: SEARCH_BAR_COLOR,
        borderRadius: BorderRadius.circular(MARGIN_SMALL),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, offset: Offset(0.0, 2.0), blurRadius: 3.0)
        ],
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        maxLines: 2,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
        ),
      ),
    );
  }
}
