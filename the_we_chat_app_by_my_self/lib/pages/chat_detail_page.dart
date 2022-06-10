import 'dart:io';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/chat_details_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/widgets/flick_video_player.dart';

const kAnimationDuration = Duration(milliseconds: 500);
List<IconData> optionIcons = [
  Icons.photo_library_outlined,
  Icons.camera_alt_outlined,
  Icons.camera,
  Icons.video_call_outlined,
  Icons.card_giftcard,
  Icons.transfer_within_a_station,
  Icons.favorite,
  Icons.location_on
];
List<String> optionLabel = [
  "Photos/video",
  "Camera",
  "Sight",
  "Video call",
  "Luck money",
  "Transfer",
  "Favourites",
  "Location"
];

class ChatDetailPage extends StatelessWidget {
  const ChatDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ChatDetailsPageBloc(),
      child: Scaffold(
        appBar: getAppBar(context),
        body: Container(),
        bottomSheet: getBottomSheet(context),
        // bottomNavigationBar: _buildBottomDrawer(context, controller),
      ),
    );
  }

  Widget getBottomSheet(BuildContext context) {
    return Consumer<ChatDetailsPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return Container(
          // padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM),
          // clipBehavior: Clip.antiAlias,
          height: null,
          color: BACKGROUND_COLOR,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                  visible: bloc.chosenFile != null,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 100,
                    width: 160,
                    child: (bloc.chosenFileType == 'mp4')
                        ? FLickVideoPlayerView(
                            postFile: bloc.chosenFile,
                          )
                        : Image.file(
                            bloc.chosenFile ?? File(""),
                            fit: BoxFit.cover,
                          ),
                  )),
              TextFieldSectionView(
                onTapAdd: () {
                  bloc.onTapMoreButton();
                },
                onTapTextField: () {
                  bloc.onTapTextField();
                },
                isPopUp: bloc.isPopUp,
              ),
              AnimatedSize(
                duration: kAnimationDuration,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.black12),
                    color: BOTTOM_NAVIGATION_BOTTOM_COLOR,
                  ),
                  width: double.infinity,
                  height: (bloc.isPopUp) ? null : 0.0,
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 8,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index) {
                      return MoreOptionButtonView(
                          onTapFunction: () async {
                            if (index == 0) {
                              FilePickerResult? result =
                                  await FilePicker.platform.pickFiles();
                              if (result != null) {
                                bloc.onChosenFile(
                                    File(result.files.single.path ?? ""),
                                    (result.files.single.extension) ?? "");
                              }
                            } else if (index == 1) {
                              final ImagePicker picker = ImagePicker();
                              XFile? result = await picker.pickImage(
                                  source: ImageSource.camera);
                              if (result != null) {
                                bloc.onChosenFile(
                                    File(result.path), result.name);
                              }
                            }
                          },
                          icon: optionIcons[index],
                          optionLabel: optionLabel[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: PRIMARY_COLOR,
      automaticallyImplyLeading: true,
      leadingWidth: MediaQuery.of(context).size.width / 4,
      leading: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Row(
          children: const [
            Icon(
              Icons.chevron_left,
              size: TEXT_LARGE,
            ),
            Text(
              LABEL_WECHAT,
              style:
                  TextStyle(color: Colors.white60, fontSize: MARGIN_MEDIUM_2),
            ),
          ],
        ),
      ),
      title: const Text("Pyi Theim Kyaw"),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person_outline_outlined),
        ),
      ],
    );
  }
}

class MoreOptionButtonView extends StatelessWidget {
  MoreOptionButtonView(
      {required this.icon,
      required this.optionLabel,
      required this.onTapFunction});

  final IconData icon;
  final String optionLabel;
  final Function onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton(
            onPressed: () {
              onTapFunction();
            },
            icon: Icon(icon, color: Colors.black54)),
        Text(
          optionLabel,
          style: const TextStyle(color: Colors.black38),
        ),
      ],
    );
  }
}

class TextFieldSectionView extends StatelessWidget {
  TextFieldSectionView({
    required this.onTapAdd,
    required this.onTapTextField,
    required this.isPopUp,
  });

  final Function onTapAdd;
  final Function onTapTextField;
  final bool isPopUp;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(
            Icons.mic,
            size: TEXT_MEDIUM,
          ),
          color: Colors.black54,
          onPressed: () {},
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: MARGIN_SMALL),
            height: null,
            // width: MediaQuery.of(context).size.width/1.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.7),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      // style: const TextStyle(
                      //
                      //   fontSize: TEXT_SMALL,
                      // ),
                      onTap: () {
                        onTapTextField();
                      },
                      maxLines: 1,
                      decoration: const InputDecoration(
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: Colors.black54,
                        size: TEXT_MEDIUM,
                      ))
                ],
              ),
            ),
          ),
        ),
        AnimatedSwitcher(
          duration: kAnimationDuration,
          child: IconButton(
            icon: Icon(
              (isPopUp) ? Icons.close : Icons.add,
            ),
            color: Colors.black54,
            onPressed: () {
              onTapAdd();
            },
          ),
        ),
      ],
    );
  }
}
