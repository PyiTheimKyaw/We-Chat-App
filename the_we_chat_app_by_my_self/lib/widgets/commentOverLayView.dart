import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class CommentOverlayView extends ModalRoute {
  Function(String) onChanged;
  Function onTapSend;

  CommentOverlayView({required this.onChanged, required this.onTapSend});

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
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: _buildOverlayContent(
          context,
          onChanged: onChanged,
          onTapSend: onTapSend,
        ),
      ),
    );
  }

  Widget _buildOverlayContent(BuildContext context,
      {required Function(String) onChanged, required Function onTapSend}) {
    return Center(
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
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
                Text(
                  auth.currentUser?.displayName ?? "",
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: TextField(
                    maxLines: 1,
                    autofocus: true,
                    onChanged: (text) {
                      onChanged(text);
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
                    onTapSend();
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
