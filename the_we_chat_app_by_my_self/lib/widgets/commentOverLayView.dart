import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class CommentOverlayView extends ModalRoute {
  String? commentTyped = null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String get barrierLabel => "";

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(context),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.start,

            children: [
              const Icon(
                Icons.chevron_right_outlined,
                color: PRIMARY_COLOR,
              ),
              Container(
                color: PRIMARY_COLOR,
                width: MediaQuery.of(context).size.width / 1.1,
                height: 0.7,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MARGIN_MEDIUM_2 + MARGIN_SMALL),
            child: Row(
              children: [
                const Text(
                  "PTK",
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    autofocus: true,
                    onChanged: (text) {
                      commentTyped = text;
                    },
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: TEXT_SMALL,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      focusColor: PRIMARY_COLOR,
                      // hintText: "Write message",
                      // hintStyle: TextStyle(
                      //   color: Colors.white,
                      //   fontSize: TEXT_REGULAR,
                      //   fontWeight: FontWeight.w400,
                      // ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pop(context, commentTyped);
                  },
                  icon: const Icon(
                    Icons.send,
                    size: 20,
                    color: PRIMARY_COLOR,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }
}
