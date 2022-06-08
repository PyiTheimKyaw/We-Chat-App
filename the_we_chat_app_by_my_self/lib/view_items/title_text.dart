import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class TitleText extends StatelessWidget {
  TitleText({Key? key, required this.title, this.textColor = Colors.white})
      : super(key: key);
  String title;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize: TEXT_REGULAR),
    );
  }
}
