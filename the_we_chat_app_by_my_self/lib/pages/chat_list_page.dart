import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:the_we_chat_app_by_my_self/pages/chatting_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/discover_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/view_items/icons_view.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          padding: const EdgeInsets.symmetric(
              horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM_2),
          itemCount: 20,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onHorizontalDragStart: (dragStart) {},
              onHorizontalDragEnd: (dragEnd) {},
              onTap: () {
                navigateToNextScreen(context, const ChattingPage());
              },
              child: Slidable(
                  endActionPane:
                      ActionPane(motion: const StretchMotion(), children: [
                    SlidableAction(
                      borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2),
                      onPressed: (context) {},
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.clear,
                    ),
                  ]),
                  child: const ChattingItemSectionView()),
            );
          },
        ),
      ),
    );
  }
}

class ChattingItemSectionView extends StatelessWidget {
  const ChattingItemSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CHATTING_SECTION_HEIGHT,
      child:
          // ListTile(
          //   leading: const CircleAvatar(
          //     radius: MARGIN_LARGE,
          //     backgroundColor: Colors.white,
          //     backgroundImage: NetworkImage(
          //         "https://sm.askmen.com/t/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.1200.jpg"),
          //   ),
          //   title: Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: const [
          //       Text(
          //         "Pyi Theim Kyaw",
          //         style: TextStyle(
          //             fontSize: TEXT_REGULAR, fontWeight: FontWeight.bold),
          //       ),
          //       Expanded(
          //         child: Text(
          //           "What's up bro,are you okay?I'm on my way! ",
          //           style: TextStyle(color: Colors.black38),
          //         ),
          //       ),
          //       Divider(),
          //     ],
          //   ),
          // ),
          Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: MARGIN_LARGE,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(
                "https://sm.askmen.com/t/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.1200.jpg"),
          ),
          const SizedBox(
            width: MARGIN_MEDIUM,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Pyi Theim Kyaw",
                  style: TextStyle(
                      fontSize: TEXT_REGULAR, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: MARGIN_SMALL,
                ),
                Expanded(
                  child: Text(
                    "What's up bro,are you okay?I'm on my way ",
                    style: TextStyle(color: Colors.black38),
                  ),
                ),
                // Divider(
                //   thickness: 1,
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
