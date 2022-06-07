import 'package:flutter/material.dart';

extension ExtensionUtility on Widget {
  void navigateToNextScreen(BuildContext context, Widget nextScreen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => nextScreen),
    );
  }
}
