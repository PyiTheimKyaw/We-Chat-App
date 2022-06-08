import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class ProfileImageView extends StatelessWidget {
  ProfileImageView({this.radius=MARGIN_LARGE});
  double radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      backgroundImage: NetworkImage(
          "https://sm.askmen.com/t/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.1200.jpg"),
    );
  }


}
