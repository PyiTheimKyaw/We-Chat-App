import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class SearchAndAddButtonView extends StatelessWidget {
  const SearchAndAddButtonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: MARGIN_MEDIUM_2),
      child: Row(
        children: const[
          Icon(Icons.search_rounded,color: Colors.white,),
          SizedBox(width: MARGIN_MEDIUM_2,),
          Icon(Icons.add,color: Colors.white,)
        ],
      ),
    );
  }
}
