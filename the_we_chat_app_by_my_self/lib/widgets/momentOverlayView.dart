import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/moments_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/pages/add_moment_page.dart';
import 'package:the_we_chat_app_by_my_self/view_items/moment_item_view.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';

class MomentOverlayView extends ModalRoute {
  MomentOverlayView({required this.moment});

  MomentVO? moment;

  String? commentTyped = null;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Color get barrierColor => Colors.transparent.withOpacity(0.9);

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
    return ChangeNotifierProvider(
      create: (BuildContext context) => MomentsPageBloc(),
      child: Material(
        elevation: 200,
        type: MaterialType.transparency,
        child: SafeArea(
          child: OverLaySectionView(moment: moment),
        ),
      ),
    );
  }
}

class OverLaySectionView extends StatelessWidget {
  OverLaySectionView({required this.moment});

  final MomentVO? moment;

  @override
  Widget build(BuildContext context) {
    return Consumer<MomentsPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return Center(
          child: MomentsItemView(
            color: Colors.white,
            isOverlay: true,
            onTapDelete: () {
              print("On Tap delete at overlay");
              bloc.onTapDelete(moment?.id ?? 0);
            },
            onTapEdit: () {
              print("On Tap edit at overlay");
              Future.delayed(Duration(seconds: 1)).then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddMomentPage(
                              momentId: moment?.id ?? 0,
                            )));
              });
            },
            moment: moment,
          ),
        );
      },
    );
  }
}
