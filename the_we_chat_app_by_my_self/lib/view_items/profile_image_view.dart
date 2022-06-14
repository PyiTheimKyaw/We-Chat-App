import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class ProfileImageView extends StatelessWidget {
  const ProfileImageView(
      {Key? key, this.radius = MARGIN_LARGE, required this.profilePicture})
      : super(key: key);
  final double radius;
  final String profilePicture;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      backgroundImage: NetworkImage(profilePicture),
    );
  }
}
