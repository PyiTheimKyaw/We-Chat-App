import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class CardItemView extends StatelessWidget {
  CardItemView({
    Key? key,
    required this.label,
    required this.icon,
  }) : super(key: key);
  String label;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      decoration:
      BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: MARGIN_XLARGE,
              color: Colors.black.withOpacity(0.5),
            ),
            const SizedBox(
              height: MARGIN_MEDIUM_2,
            ),
            Text(label,textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}