import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class TitleSectionView extends StatelessWidget {
  const TitleSectionView({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style:
      const TextStyle(fontSize: TEXT_REGULAR, fontWeight: FontWeight.w400),
    );
  }
}