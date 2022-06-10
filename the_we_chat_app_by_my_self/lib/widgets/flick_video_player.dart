import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';

class FLickVideoPlayerView extends StatefulWidget {
  FLickVideoPlayerView(
      {this.postFile, this.isMomentsPage = false, this.momentFile});

  File? postFile;
  bool isMomentsPage;
  String? momentFile;

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
      autoPlay: false,
      videoPlayerController: (widget.momentFile != null && widget.postFile ==null)
          ? VideoPlayerController.network(widget.momentFile ?? "")
          : VideoPlayerController.file(widget.postFile ?? File("")),
    );
  }
  @override
  void dispose(){
    flickManager.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FlickVideoPlayer(flickManager: flickManager);
  }
}
