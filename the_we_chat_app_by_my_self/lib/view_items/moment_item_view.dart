import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';
import 'package:the_we_chat_app_by_my_self/widgets/commentOverLayView.dart';
import 'package:the_we_chat_app_by_my_self/widgets/flick_video_player.dart';

class MomentsItemView extends StatelessWidget {
  MomentsItemView({
    Key? key,
    required this.moment,
    required this.onTapDelete,
    required this.onTapEdit,
    this.isOverlay = false,
    this.color = Colors.black,
  }) : super(key: key);
  final MomentVO? moment;
  final Function onTapDelete;
  final Function onTapEdit;
  final bool isOverlay;
  final Color color;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: post,
      margin: const EdgeInsets.only(top: MARGIN_LARGE),
      decoration: BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey,
        //     offset: Offset(0.0, 1.0), //(x,y)
        //     blurRadius: 6.0,
        //   ),
        // ],
        color: (isOverlay) ? Colors.transparent : Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_SMALL),
        height: null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: (isOverlay) ? MARGIN_SMALL : PROFILE_HEIGHT),
              child: TitleText(
                title: moment?.userName ?? "",
                textColor: color,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: (isOverlay) ? MARGIN_SMALL : MARGIN_LARGE,
                  top: MARGIN_MEDIUM,
                  bottom: MARGIN_LARGE),
              child: Text(
                moment?.description ?? "",
                style: TextStyle(color: color),
              ),
            ),
            MomentImageView(
              fileType: moment?.fileType ?? "",
              momentImage: moment?.postFile,
            ),
            const SizedBox(
              height: MARGIN_SMALL,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.favorite_border,
                  color: color,
                ),
                const SizedBox(
                  width: MARGIN_SMALL,
                ),
                CommentButtonView(
                  color: color,
                ),
                const SizedBox(
                  width: MARGIN_SMALL,
                ),
                Visibility(
                  visible: moment?.userId == auth.currentUser?.uid,
                  child: MoreButtonView(
                    onTapEdit: onTapEdit,
                    onTapDelete: onTapDelete,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MomentImageView extends StatelessWidget {
  MomentImageView({
    Key? key,
    required this.momentImage,
    required this.fileType,
  }) : super(key: key);
  String? momentImage;
  String fileType;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: momentImage != "",
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        height: MOMENT_IMAGE_HEIGHT,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MARGIN_SMALL),
        ),
        child: (fileType == "mp4")
            ? FLickVideoPlayerView(
                isMomentsPage: true,
                momentFile: momentImage,
              )
            : Image.network(
                momentImage ?? "",
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class CommentButtonView extends StatelessWidget {
  CommentButtonView({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.comment_outlined,
        color: color,
      ),
      onPressed: () {
        print("comment print");
        Navigator.of(context).push(CommentOverlayView());
      },
    );
  }
}

class MoreButtonView extends StatelessWidget {
  MoreButtonView({
    Key? key,
    required this.onTapDelete,
    required this.onTapEdit,
  }) : super(key: key);
  final Function onTapDelete;
  final Function onTapEdit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            onTapEdit();
          },
          child: const Text("Edit"),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () {
            onTapDelete();
          },
          child: const Text("Delete"),
        ),
      ],
      child: const Icon(
        Icons.more_horiz_outlined,
        color: Colors.grey,
      ),
    );
  }
}
