import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class ChattingItemView extends StatelessWidget {
   ChattingItemView({
    Key? key,
    this.isContact=true,
  }) : super(key: key);
  bool isContact;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CHATTING_SECTION_HEIGHT,
      child: Row(
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
              children:  [
                const Text(
                  "Pyi Theim Kyaw",
                  style: TextStyle(
                      fontSize: TEXT_REGULAR, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: MARGIN_SMALL,
                ),
                const Expanded(
                  child: Text(
                    "What's up bro,are you okay?I'm on my way ",
                    style: TextStyle(color: Colors.black38),
                  ),
                ),
                Visibility(

                  visible:isContact,
                  child: const Divider(
                    thickness: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}