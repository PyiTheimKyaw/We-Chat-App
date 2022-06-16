import 'dart:io';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/add_moments_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/view_items/loading_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/profile_image_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';
import 'package:the_we_chat_app_by_my_self/widgets/flick_video_player.dart';

import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';

class AddMomentPage extends StatefulWidget {
  AddMomentPage({Key? key, this.momentId}) : super(key: key);
  int? momentId;

  @override
  State<AddMomentPage> createState() => _AddMomentPageState();
}

class _AddMomentPageState extends State<AddMomentPage> {
  var controller = BottomDrawerController();

  @override
  void initState() {
    controller.open();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) =>
          AddMomentsPageBloc(momentId: widget.momentId),
      child: Selector<AddMomentsPageBloc, bool>(
        selector: (BuildContext context, bloc) => bloc.isLoading,
        builder: (BuildContext context, isLoading, Widget? child) {
          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  elevation: 0,
                  backgroundColor: PRIMARY_COLOR,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      )),
                  centerTitle: true,
                  title: Text(
                      (widget.momentId == null) ? "Create Post" : "Edit Post"),
                  actions: [
                    Consumer<AddMomentsPageBloc>(
                      builder: (BuildContext context, bloc, Widget? child) {
                        return TextButton(
                          onPressed: () {
                            if (bloc.isAddNewMomentError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Post shouldn't be empty")));
                            } else {
                              bloc
                                  .onTapAddNewMoment()
                                  .then((value) => Navigator.pop(context));
                            }
                          },
                          child: const Text("Post",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: TEXT_REGULAR)),
                        );
                      },
                    ),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBarSectionView(
                  controller: controller,
                ),
                body: Consumer<AddMomentsPageBloc>(
                  builder: (BuildContext context, bloc, Widget? child) {
                    return Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: MARGIN_MEDIUM_2),
                          width: double.infinity,
                          height: double.infinity,
                          color: Colors.white,
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                UserProfileAndPostOptionsSectionView(
                                  profilePic: bloc.profilePicture ?? "",
                                  userName: bloc.userName ?? "",
                                ),
                                const SizedBox(
                                  height: MARGIN_LARGE,
                                ),
                                MomentsDescriptionTextFieldView(
                                  controller: controller,
                                ),
                                Stack(
                                  children: [
                                    Visibility(
                                      visible: (bloc.chosenPostImage != null ||
                                          bloc.postImage != ''),
                                      child: Container(
                                        width: double.infinity,
                                        height: null,
                                        color: Colors.red,
                                        child: (bloc.fileType == 'mp4')
                                            ? FLickVideoPlayerView(
                                                momentFile: bloc.postImage,
                                                postFile: bloc.chosenPostImage,
                                              )
                                            : (bloc.chosenPostImage == null)
                                                ? Image.network(
                                                    bloc.postImage,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.file(
                                                    bloc.chosenPostImage ??
                                                        File(""),
                                                    fit: BoxFit.cover,
                                                  ),
                                        // (bloc.fileType == "mp4")
                                        //     ? FLickVideoPlayerView(
                                        //         postFile: bloc.chosenPostImage,momentFile: bloc.postImage,)
                                        //     : (bloc.chosenPostImage ==null) ?Image.file(
                                        //         bloc.chosenPostImage ??
                                        //             File(""),
                                        //         fit: BoxFit.cover,
                                        //       ): Image.network(bloc.postImage ?? "",fit: BoxFit.cover,),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Visibility(
                                          visible:
                                              (bloc.chosenPostImage != null ||
                                                  bloc.postImage != ''),
                                          child: IconButton(
                                            icon: Icon(Icons.close,
                                                color: Colors.red),
                                            onPressed: () {
                                              bloc.onChosenDeleteFile();
                                            },
                                          )),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                            visible: bloc.isDrawerPop,
                            child: _buildBottomDrawer(context, controller)),
                      ],
                    );
                  },
                ),
              ),
              Visibility(
                  visible: isLoading,
                  child: Container(
                    color: Colors.black12,
                    child: const Center(
                      child: LoadingView(),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}



class BottomNavigationBarSectionView extends StatelessWidget {
  BottomNavigationBarSectionView({Key? key, required this.controller})
      : super(key: key);
  BottomDrawerController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<AddMomentsPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return NavigationBarTheme(
          data: NavigationBarThemeData(
            height: MediaQuery.of(context).size.height / 12,
            indicatorColor: Colors.white,
          ),
          child: Visibility(
            visible: !bloc.isDrawerPop,
            child: NavigationBar(
              backgroundColor: Colors.white,
              elevation: 10,
              selectedIndex: bloc.currentIndex,
              onDestinationSelected: (int newIndex) async {
                bloc.onChosenIndex(newIndex);
                if (newIndex == 0) {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    print("File Type => ${result.files.single.extension}");
                    bloc.onChosenPostImage(File(result.files.single.path ?? ""),
                        result.files.single.extension ?? "");
                  }
                } else if (newIndex == 4) {
                  bloc.onTapMoreToDrawerPop().whenComplete(() {
                    Future.delayed(Duration(seconds: 1))
                        .then((value) => controller.open());
                  });
                }
              },
              destinations: const [
                NavigationDestination(
                    selectedIcon: Icon(
                      Icons.photo_library_rounded,
                      color: Colors.green,
                    ),
                    icon: Icon(
                      Icons.photo_library_outlined,
                      color: Colors.green,
                    ),
                    label: ''),
                NavigationDestination(
                    icon: Icon(
                      Icons.person_add_alt,
                      color: Colors.blue,
                    ),
                    selectedIcon: Icon(
                      Icons.person_add_alt,
                      color: Colors.blue,
                    ),
                    label: ''),
                NavigationDestination(
                    icon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.yellow,
                    ),
                    selectedIcon: Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.yellow,
                    ),
                    label: ''),
                NavigationDestination(
                  icon: Icon(
                    Icons.location_on,
                    color: Colors.orange,
                  ),
                  selectedIcon: Icon(
                    Icons.location_on,
                    color: Colors.orange,
                  ),
                  label: '',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.black,
                  ),
                  selectedIcon: Icon(
                    Icons.more_horiz_rounded,
                    color: Colors.black,
                  ),
                  label: '',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MomentsDescriptionTextFieldView extends StatelessWidget {
  MomentsDescriptionTextFieldView({
    Key? key,
    required this.controller,
  }) : super(key: key);
  BottomDrawerController controller;


  @override
  Widget build(BuildContext context) {
    return Consumer<AddMomentsPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
          child: Container(
            height: null,
            child: TextField(
              controller: bloc.textEditingController,
              onTap: () {
                controller.close();
              },
              // onChanged: (text) {
              //   print(text);
              //   bloc.onNewPostTextChanged(text);
              // },
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "What's in your mind?",
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget _buildBottomDrawer(
    BuildContext context, BottomDrawerController controller) {
  return BottomDrawer(
    header: _buildBottomDrawerHead(context),
    body: _buildBottomDrawerBody(context),
    headerHeight: DRAWER_HEADER_HEIGHT,
    drawerHeight: DRAWER_BODY_HEIGHT,
    color: Colors.white,
    controller: controller,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.15),
        blurRadius: 60,
        spreadRadius: 5,
        offset: const Offset(2, -6), // changes position of shadow
      ),
    ],
  );
}

Widget _buildBottomDrawerHead(BuildContext context) {
  return SizedBox(
      height: DRAWER_HEADER_HEIGHT,
      child: Center(
        child: Container(
          width: MARGIN_XLARGE,
          height: 3,
          color: Colors.black54,
        ),
      ));
}

Widget _buildBottomDrawerBody(BuildContext context) {
  return Container(
    width: double.infinity,
    height: DRAWER_BODY_HEIGHT,
    child: SingleChildScrollView(
      child: Consumer<AddMomentsPageBloc>(
        builder: (BuildContext context, bloc, Widget? child) {
          return Column(
            children: [
              ListTitlePostActionsView(
                icon: Icons.photo_library_rounded,
                label: "Photo/video",
                iconColor: Colors.green,
                onTapListTile: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    print("File Type => ${result.files.single.extension}");
                    bloc.onChosenPostImage(File(result.files.single.path ?? ""),
                        result.files.single.extension ?? "");
                  }
                },
              ),
              Divider(),
              ListTitlePostActionsView(
                icon: Icons.person_add_alt_1,
                label: "Tag people",
                iconColor: Colors.blue,
                onTapListTile: () {},
              ),
              Divider(),
              ListTitlePostActionsView(
                icon: Icons.emoji_emotions_outlined,
                label: "Feeling/activity",
                iconColor: Colors.yellow,
                onTapListTile: () {},
              ),
              Divider(),
              ListTitlePostActionsView(
                icon: Icons.location_on,
                label: "Check in",
                iconColor: Colors.orange,
                onTapListTile: () {},
              ),
              Divider(),
              ListTitlePostActionsView(
                icon: Icons.video_call,
                label: "Live Video",
                iconColor: Colors.red,
                onTapListTile: () {},
              ),
              Divider(),
              ListTitlePostActionsView(
                icon: Icons.text_increase_outlined,
                label: "Background colour",
                iconColor: Colors.greenAccent,
                onTapListTile: () {},
              ),
              Divider(),
              ListTitlePostActionsView(
                icon: Icons.camera_alt,
                label: "Camera",
                iconColor: Colors.blueAccent,
                onTapListTile: () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    bloc.onChosenPostImage(File(image.path), image.name);
                  }
                },
              ),
              Divider(),
              ListTitlePostActionsView(
                icon: Icons.gif_rounded,
                label: "GIF",
                iconColor: Colors.greenAccent,
                onTapListTile: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    print("File Type => ${result.files.single.extension}");
                    bloc.onChosenPostImage(File(result.files.single.path ?? ""),
                        result.files.single.extension ?? "");
                  }
                },
              ),
              Divider(),
              ListTitlePostActionsView(
                icon: Icons.mic_rounded,
                label: "Host a Q&A",
                iconColor: Colors.red,
                onTapListTile: () {},
              ),
            ],
          );
        },
      ),
    ),
  );
}

class ListTitlePostActionsView extends StatelessWidget {
  ListTitlePostActionsView({
    Key? key,
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.onTapListTile,
  }) : super(key: key);
  IconData icon;
  String label;
  Color iconColor;
  Function onTapListTile;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      child: Center(
        child: ListTile(
          minVerticalPadding: 1,
          leading: Icon(
            icon,
            color: iconColor,
          ),
          title: Text(
            label,
          ),
          onTap: () {
            onTapListTile();
          },
        ),
      ),
    );
  }
}

class UserProfileAndPostOptionsSectionView extends StatelessWidget {
  UserProfileAndPostOptionsSectionView({
    Key? key,
    required this.profilePic,
    required this.userName,
  }) : super(key: key);
  String profilePic;
  String userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImageView(
            profilePicture: profilePic ?? "",
          ),
          const SizedBox(
            width: MARGIN_MEDIUM,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                title: userName,
                textColor: Colors.black,
              ),
              const SizedBox(
                height: MARGIN_MEDIUM,
              ),
              const PostOptionsSectionView(),
            ],
          ),
        ],
      ),
    );
  }
}

class PostOptionsSectionView extends StatelessWidget {
  const PostOptionsSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OptionView(
          centerLabel: LABEL_ONLY_ME,
          firstIcon: Icons.lock,
          secIcon: Icons.expand_more,
        ),
        const SizedBox(
          width: MARGIN_SMALL,
        ),
        OptionView(
          centerLabel: LABEL_ALBUM,
          firstIcon: Icons.add,
          secIcon: Icons.expand_more,
        ),
        const SizedBox(
          width: MARGIN_SMALL,
        ),
        OptionView(
          centerLabel: LABEL_OFF,
          firstIcon: Icons.camera,
          secIcon: Icons.expand_more,
        ),
        // Card(
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.circular(2.0),
        //   ),
        //   elevation: 3,
        //   child: Padding(
        //     padding: const EdgeInsets.all(8.0),
        //     child: Row(
        //       children: [
        //         Icon(Icons.arrow_drop_down_outlined),
        //         Text("Only me"),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }
}

class OptionView extends StatelessWidget {
  OptionView({
    Key? key,
    required this.centerLabel,
    required this.firstIcon,
    required this.secIcon,
  }) : super(key: key);
  String centerLabel;
  IconData firstIcon;
  IconData secIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: null,
      height: null,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 1, color: Colors.black38),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Row(
          children: [
            Icon(
              firstIcon,
              size: MARGIN_MEDIUM,
              color: Colors.black,
            ),
            Text(centerLabel),
            Icon(
              secIcon,
              size: MARGIN_MEDIUM,
              color: Colors.black,
            ),
          ],
        ),
      )),
    );
  }
}

void showSnackBarWithMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
