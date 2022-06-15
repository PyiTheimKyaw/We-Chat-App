import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/chat_list_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/pages/chat_detail_page.dart';
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
    return ChangeNotifierProvider(
      create: (BuildContext context) => ChatListPageBloc(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
        body: Consumer<ChatListPageBloc>(

          builder: (BuildContext context, bloc, Widget? child) {
            return Container(
              color: Colors.white,
              child: ChattingHistoryListSectionView(
                onTapUser: (user) {
                  navigateToNextScreen(context, ChatDetailPage(chatUser: user));
                },
                userList: bloc.chattedUsersList ?? [], messages: bloc.conversation ?? [],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChattingHistoryListSectionView extends StatelessWidget {
  const ChattingHistoryListSectionView({
    Key? key,
    required this.onTapUser,
    required this.userList,
    required this.messages,
  }) : super(key: key);
  final Function(UserVO) onTapUser;
  final List<UserVO> userList;
  final List<String> messages;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (BuildContext context, int index) => Divider(),
      padding: const EdgeInsets.symmetric(vertical: MARGIN_MEDIUM_2),
      itemCount: userList.length ?? 0,
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onHorizontalDragStart: (dragStart) {},
          onHorizontalDragEnd: (dragEnd) {},
          onTap: () {
            onTapUser(userList[index]);
          },
          child: Slidable(
              endActionPane:
                  ActionPane(motion: const StretchMotion(), children: [
                SlidableAction(
                  flex: 2,
                  onPressed: (context) {},
                  backgroundColor: BACKGROUND_COLOR,
                  foregroundColor: Colors.red,
                  icon: Icons.cancel,
                ),
              ]),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
                child: ChattingItemView(
                  lastMessage: messages[index],
                  user: userList[index],
                  isContact: false,
                ),
              )),
        );
      },
    );
  }
}
