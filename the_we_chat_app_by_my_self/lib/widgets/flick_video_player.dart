import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class FLickVideoPlayerView extends StatefulWidget {
  FLickVideoPlayerView({required this.postFile});

  File? postFile;

  @override
  _FLickVideoPlayerViewState createState() => _FLickVideoPlayerViewState();
}

class _FLickVideoPlayerViewState extends State<FLickVideoPlayerView> {
  late FlickManager flickManager;
  late VideoPlayerController videoPlayerController;

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.file(widget.postFile ?? File("")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(flickManager: flickManager);
  }
}
