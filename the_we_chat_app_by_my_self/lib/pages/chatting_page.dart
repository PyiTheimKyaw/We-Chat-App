import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class ChattingPage extends StatelessWidget {
  const ChattingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: PRIMARY_COLOR,
        automaticallyImplyLeading: true,
        leadingWidth: 90,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Row(
            children: const [
              Icon(
                Icons.chevron_left,
                size: TEXT_LARGE,
              ),
              Text(
                "WeChat",
                style: TextStyle(
                    color: Colors.white60, fontSize: MARGIN_MEDIUM_2),
              ),
            ],
          ),
        ),
        title: const Text("Pyi Theim Kyaw"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.person_outline_outlined),
          ),
        ],
      ),
    );
  }
}
