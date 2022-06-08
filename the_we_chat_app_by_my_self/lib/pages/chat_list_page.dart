import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:the_we_chat_app_by_my_self/pages/chatting_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/discover_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/view_items/chatting_item_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/icons_view.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PRIMARY_COLOR,
        centerTitle: true,
        title: TitleText(title: LABEL_WECHAT),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            color: Colors.white,
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: const ChattingHistoryListSectionView(),
      ),
    );
  }
}

class ChattingHistoryListSectionView extends StatelessWidget {
  const ChattingHistoryListSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      padding: const EdgeInsets.symmetric(vertical: MARGIN_MEDIUM_2),
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
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
                child: ChattingItemView(
                  isContact: false,
                ),
              )),
        );
      },
    );
  }
}
