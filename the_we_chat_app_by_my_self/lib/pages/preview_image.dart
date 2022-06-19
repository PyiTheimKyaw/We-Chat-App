import 'package:flutter/material.dart';

class PreviewImage extends StatelessWidget {
  const PreviewImage({Key? key,required this.photoUrl}) : super(key: key);
  final String photoUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: Colors.transparent,
        child: Center(
          child: Image.network(photoUrl),
        ),
      ),
    );
  }
}
