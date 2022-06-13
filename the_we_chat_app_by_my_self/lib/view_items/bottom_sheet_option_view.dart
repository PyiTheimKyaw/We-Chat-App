import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class BottomSheetOptionView extends StatelessWidget {
  const BottomSheetOptionView({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);
  final String label;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          onTap();
        },
        child: Text(
          label,
          style: const TextStyle(
              fontSize: TEXT_MEDIUM - TEXT_SMALL,
              color: Colors.black,
              fontWeight: FontWeight.w400),
        ));
  }
}