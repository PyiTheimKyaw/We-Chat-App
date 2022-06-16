import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/utils/time_ago.dart';

class ChattingItemView extends StatelessWidget {
  ChattingItemView({
    Key? key,
    this.isContact = true,
    required this.user,
    required this.lastMessage,
    required this.date,
  }) : super(key: key);
  bool isContact;
  final UserVO? user;
  final ContactAndMessageVO? lastMessage;
  final int date;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CHATTING_SECTION_HEIGHT,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: MARGIN_LARGE,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(user?.profilePicture ?? ""),
          ),
          const SizedBox(
            width: MARGIN_MEDIUM,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.userName ?? "",
                  style: const TextStyle(
                      fontSize: TEXT_REGULAR, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: MARGIN_SMALL,
                ),
                Expanded(
                  child: Text(
                    (lastMessage?.fileType != "")
                        ? (lastMessage?.fileType == "mp4")
                            ? "sent a video"
                            : "sent a photo"
                        : lastMessage?.messages ?? "",
                    style: const TextStyle(color: Colors.black38),
                  ),
                ),
                Visibility(
                  visible: isContact,
                  child: const Divider(
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
          Text(
            TimeAgo.dateAgo(date),
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
