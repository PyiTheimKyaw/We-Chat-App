import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_vo.dart';
import 'package:the_we_chat_app_by_my_self/dummy_data/contacts.dart';
import 'package:the_we_chat_app_by_my_self/pages/chatting_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/view_items/card_item_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/chatting_item_view.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<ContactVO> userList = contactsList;
  List<String> strList = [];
  List<Widget> normalList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // for (var i = 0; i < 26; i++) {
    //   userList.add(ContactVO(username:getRandomName(), subTitle:getRandomName(), profilePicture: ""));
    // }


    // userList.map((element) {
    //   strList.add(element.username ?? "");
    // }).toList();
    userList.sort((a, b) => (a.username ?? "")
        .toLowerCase()
        .compareTo((b.username ?? "").toLowerCase()));
    filterList();
    searchController.addListener(() {
      filterList();
    });
    super.initState();
  }

  filterList() {
    List<ContactVO> users = [];
    users.addAll(userList);

    normalList = [];
    strList = [];
    if (searchController.text.isNotEmpty) {
      users.retainWhere((user) => (user.username ?? "")
          .toLowerCase()
          .contains(searchController.text.toLowerCase()));
    }
    users.forEach((user) {
      normalList.add(
        Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePicture ?? ""),
              ),
              title: Text(user.username ?? ""),
              subtitle: Text(user.subTitle ?? ""),
            ),
           const Divider(),
          ],
        ),
      );
      strList.add(user.username ?? "");
    });

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

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
          return  [
            SliverToBoxAdapter(
              child: SearBarSectionView(controller: searchController,),
            ),
            const SliverToBoxAdapter(
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
              // const ContactsListSectionView(),
              Container(
                margin: const EdgeInsets.only(top: MARGIN_XLARGE * 1.5),
                height: post,
                color: Colors.white,
                child: AlphabetListScrollView(
                  strList: strList,
                  highlightTextStyle: const TextStyle(
                    color: Colors.blue,
                  ),
                  showPreview: true,
                  itemBuilder: (context, index) {
                    print("index $index");
                    return normalList[index];
                  },
                  indexedHeight: (i) {
                    return 89;
                  },
                  keyboardUsage: true,
                  // headerWidgetList: <AlphabetScrollListHeader>[
                  //   AlphabetScrollListHeader(widgetList: [
                  //     Padding(
                  //       padding: const EdgeInsets.all(16.0),
                  //       child: TextFormField(
                  //         controller: searchController,
                  //         decoration: InputDecoration(
                  //           border: OutlineInputBorder(),
                  //           suffix: Icon(
                  //             Icons.search,
                  //             color: Colors.grey,
                  //           ),
                  //           labelText: "Search",
                  //         ),
                  //       ),
                  //     )
                  //   ], icon: Icon(Icons.search), indexedHeaderHeight: (index) => 80),
                  // ],
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width * 0.2,
                top: MediaQuery.of(context).size.width * 0.06,
                child:  ContactPerfixSectionView(contactPrefix: "A",),
              ),
               Align(
                alignment: Alignment.topRight,
                child: FriendsCountSectionView(friendCount: userList.length),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.only(
          top: MARGIN_LARGE * 1.2, right: MARGIN_MEDIUM_2),
      child: Text(
        "$friendCount Friends",
        style: TextStyle(
            color: Colors.black.withOpacity(0.5), fontSize: TEXT_SMALL),
      ),
    );
  }
}

class ContactPerfixSectionView extends StatelessWidget {
   ContactPerfixSectionView({
    Key? key,
    required this.contactPrefix,
  }) : super(key: key);
  String contactPrefix;

  @override
  Widget build(BuildContext context) {
    return Text(
      contactPrefix,
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
   SearBarSectionView({
    Key? key,
    required this.controller,
  }) : super(key: key);
   TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: SEARCH_BAR_COLOR,
        borderRadius: BorderRadius.circular(MARGIN_SMALL),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, offset: Offset(0.0, 2.0), blurRadius: 3.0)
        ],
      ),
      child:  TextField(
        controller: controller,
        textAlign: TextAlign.center,
        maxLines: 2,
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Search",
        ),
      ),
    );
  }
}
