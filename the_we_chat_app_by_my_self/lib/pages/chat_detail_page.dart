import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/chat_details_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/contact_and_message_vo.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/user_vo.dart';
import 'package:the_we_chat_app_by_my_self/pages/preview_image.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/utils/time_ago.dart';
import 'package:the_we_chat_app_by_my_self/view_items/profile_image_view.dart';
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
  ChatDetailPage({Key? key, required this.chatUser}) : super(key: key);
  UserVO? chatUser;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          ChatDetailsPageBloc(chatUser ?? UserVO()),
      child: Selector<ChatDetailsPageBloc, List<ContactAndMessageVO>?>(
        selector: (BuildContext context, bloc) => bloc.conversationsList,
        shouldRebuild: (previous, next) => previous != next,
        builder: (BuildContext context, conversations, Widget? child) {
          return Scaffold(
            appBar: getAppBar(context, name: chatUser?.userName ?? ""),
            body: Container(
              alignment: Alignment.bottomCenter,
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: MARGIN_MEDIUM_2,
                          vertical: MARGIN_MEDIUM_2),
                      child: ListView.builder(
                        reverse: true,
                        itemCount: conversations?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return Consumer<ChatDetailsPageBloc>(
                            builder:
                                (BuildContext context, bloc, Widget? child) {
                              return Message(
                                conversations:
                                    conversations?.reversed.elementAt(index),
                                loggedInUser: bloc.loggedInUser,
                                chattedUser: chatUser,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  getBottomSheet(context),
                ],
              ),
            ),
            // bottomSheet: getBottomSheet(context),
            // bottomNavigationBar: _buildBottomDrawer(context, controller),
          );
        },
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: bloc.chosenFile != null,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: MARGIN_MEDIUM,
                      horizontal: MARGIN_XLARGE + MARGIN_SMALL),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: null,
                  width: 170,
                  child: Stack(children: [
                    ChosenFileView(bloc.chosenFile, bloc.chosenFileType),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        alignment: Alignment.topRight,
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () {
                          bloc.onTapCancel();
                        },
                      ),
                    ),
                  ]),
                ),
              ),
              TextFieldSectionView(
                onSubmitted: bloc.onSubmitted,
                onTapAdd: () {
                  bloc.onTapMoreButton();
                },
                onTapTextField: () {
                  bloc.onTapTextField();
                },
                isPopUp: bloc.isPopUp,
                controller: bloc.controller,
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
                    physics: const NeverScrollableScrollPhysics(),
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

  PreferredSizeWidget getAppBar(BuildContext context, {required String name}) {
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
      title: Text(name),
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

class ChosenFileView extends StatelessWidget {
  const ChosenFileView(this.chosenFile, this.chosenFileType, {Key? key})
      : super(key: key);

  final File? chosenFile;
  final String? chosenFileType;

  @override
  Widget build(BuildContext context) {
    return (chosenFileType == 'mp4')
        ? FLickVideoPlayerView(
            postFile: chosenFile,
          )
        : Image.file(
            chosenFile ?? File(""),
            fit: BoxFit.cover,
          );
  }
}

class Message extends StatelessWidget {
  const Message({
    Key? key,
    required this.conversations,
    required this.loggedInUser,
    required this.chattedUser,
  }) : super(key: key);
  final ContactAndMessageVO? conversations;
  final UserVO? loggedInUser;
  final UserVO? chattedUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          right: (conversations?.id != loggedInUser?.id)
              ? MediaQuery.of(context).size.width / 3
              : 0,
          left: (conversations?.id != loggedInUser?.id)
              ? 0
              : MediaQuery.of(context).size.width / 3,
          top: MARGIN_MEDIUM_2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: (conversations?.id != loggedInUser?.id)
            ? MainAxisAlignment.start
            : MainAxisAlignment.end,
        children: [
          Visibility(
              visible: (conversations?.id != loggedInUser?.id),
              child: ProfileImageView(
                profilePicture: chattedUser?.profilePicture ?? "",
                radius: MARGIN_MEDIUM_2 + 3,
              )),
          const SizedBox(
            width: MARGIN_SMALL,
          ),
          Expanded(
              child: TextMessage(
            conversations: conversations,
            loggedInUser: loggedInUser,
          )),
        ],
      ),
    );
  }
}

class TextMessage extends StatelessWidget {
  const TextMessage(
      {Key? key, required this.conversations, required this.loggedInUser})
      : super(key: key);

  final ContactAndMessageVO? conversations;
  final UserVO? loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: (conversations?.id != loggedInUser?.id)
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: (conversations?.id != loggedInUser?.id)
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: (conversations?.id != loggedInUser?.id),
          child: Text(
            TimeAgo.timeAgoSinceDateNow(conversations?.timeStamp ?? 0),
            style: const TextStyle(color: Colors.black26),
          ),
        ),
        (conversations?.messages != "" && conversations?.file != "")
            ? MessageAndFileNotNullSectionView(
                conversations: conversations,
                loggedInUser: loggedInUser,
              )
            : MessageOrFileNotNullSectionView(conversations: conversations),
      ],
    );
  }
}

class MessageAndFileNotNullSectionView extends StatelessWidget {
  const MessageAndFileNotNullSectionView({
    Key? key,
    required this.conversations,
    required this.loggedInUser,
  }) : super(key: key);

  final ContactAndMessageVO? conversations;
  final UserVO? loggedInUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: null,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
          color: BACKGROUND_COLOR,
          borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2)),
      child: Column(
        crossAxisAlignment: (conversations?.id != loggedInUser?.id)
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          (conversations?.fileType == 'mp4')
              ? FLickVideoPlayerView(
                  momentFile: conversations?.file,
                )
              : GestureDetector(
                  onTap: () {
                    print("Tap");
                    navigateToNextScreen(context,
                        PreviewImage(photoUrl: conversations?.file ?? ""));
                  },
                  child: Image.network(
                    conversations?.file ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              conversations?.messages ?? "",
            ),
          )
        ],
      ),
    );
  }
}

class MessageOrFileNotNullSectionView extends StatelessWidget {
  const MessageOrFileNotNullSectionView({
    Key? key,
    required this.conversations,
  }) : super(key: key);

  final ContactAndMessageVO? conversations;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
            visible: conversations?.file != "",
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2)),
              margin: const EdgeInsets.only(bottom: MARGIN_MEDIUM),
              height: (conversations?.fileType == 'mp4') ? null : null,
              width: (conversations?.fileType == 'mp4') ? 200 : 200,
              child: (conversations?.fileType == 'mp4')
                  ? FLickVideoPlayerView(
                      momentFile: conversations?.file,
                    )
                  : GestureDetector(
                      onTap: () {
                        print("Tap");
                        navigateToNextScreen(context,
                            PreviewImage(photoUrl: conversations?.file ?? ""));
                      },
                      child: Image.network(
                        conversations?.file ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
            )),
        Visibility(
          visible: conversations?.messages != "",
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_MEDIUM),
            decoration: BoxDecoration(
                color: BACKGROUND_COLOR,
                borderRadius: BorderRadius.circular(MARGIN_MEDIUM_2)),
            child: Text(
              conversations?.messages ?? "",
            ),
          ),
        ),
      ],
    );
  }
}

class MoreOptionButtonView extends StatelessWidget {
  const MoreOptionButtonView(
      {Key? key,
      required this.icon,
      required this.optionLabel,
      required this.onTapFunction})
      : super(key: key);

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
  const TextFieldSectionView({
    Key? key,
    required this.onTapAdd,
    required this.onTapTextField,
    required this.isPopUp,
    required this.onSubmitted,
    required this.controller,
  }) : super(key: key);

  final Function onTapAdd;
  final Function onTapTextField;
  final bool isPopUp;
  final ValueChanged<String> onSubmitted;
  final TextEditingController controller;

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
                      controller: controller,
                      onTap: () {
                        onTapTextField();
                      },
                      maxLines: 1,
                      decoration: const InputDecoration(
                          hintText: "Message...",
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                      onSubmitted: onSubmitted,
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
