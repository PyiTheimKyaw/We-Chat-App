import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: MARGIN_XLARGE,
      height: MARGIN_XLARGE,
      child: LoadingIndicator(
        indicatorType: Indicator.ballBeat,
        colors: [Colors.red],
        strokeWidth: 2,
        backgroundColor: Colors.transparent,
        pathBackgroundColor: Colors.black,
      ),
    );
  }
}