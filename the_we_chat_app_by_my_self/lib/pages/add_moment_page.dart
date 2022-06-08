import 'dart:io';

import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/add_moments_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/view_items/profile_image_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';

BottomDrawerController _controller = BottomDrawerController();

class AddMomentPage extends StatelessWidget {
  const AddMomentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => AddMomentsPageBloc(),
      child: Scaffold(
        appBar: AppBar(
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
          title: const Text("Create Post"),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text("Post",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: TEXT_REGULAR)),
            ),
          ],
        ),
        body: Consumer<AddMomentsPageBloc>(
          builder: (BuildContext context, bloc, Widget? child) {
            return Stack(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: MARGIN_MEDIUM_2),
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const UserProfileAndPostOptionsSectionView(),
                        const SizedBox(
                          height: MARGIN_LARGE,
                        ),
                        const MomentsDescriptionTextFieldView(),
                        Visibility(
                          visible: bloc.chosenPostImage!=null,
                          child: Container(
                            width: double.infinity,
                            height: 400,
                            color: Colors.red,
                            child: Image.file(bloc.chosenPostImage ?? File("")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _buildBottomDrawer(context),
              ],
            );
          },
        ),
      ),
    );
  }
}

class MomentsDescriptionTextFieldView extends StatelessWidget {
  const MomentsDescriptionTextFieldView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: TextField(
        maxLines: 6,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "What's in your mind?",
        ),
      ),
    );
  }
}

Widget _buildBottomDrawer(BuildContext context) {
  return BottomDrawer(
    header: _buildBottomDrawerHead(context),
    body: _buildBottomDrawerBody(context),
    headerHeight: DRAWER_HEADER_HEIGHT,
    drawerHeight: DRAWER_BODY_HEIGHT,
    color: Colors.white,
    controller: _controller,
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
                    bloc.onChosenPostImage(
                        File(result.files.single.path ?? ""));
                  }
                },
              ),
              ListTitlePostActionsView(
                icon: Icons.person_add_alt_1,
                label: "Tag people",
                iconColor: Colors.blue,
                onTapListTile: () {},
              ),
              ListTitlePostActionsView(
                icon: Icons.emoji_emotions_outlined,
                label: "Feeling/activity",
                iconColor: Colors.yellow,
                onTapListTile: () {},
              ),
              ListTitlePostActionsView(
                icon: Icons.location_on,
                label: "Check in",
                iconColor: Colors.orange,
                onTapListTile: () {},
              ),
              ListTitlePostActionsView(
                icon: Icons.video_call,
                label: "Live Video",
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
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor,
      ),
      title: Text(label),
      onTap: () {
        onTapListTile();
      },
    );
  }
}

class UserProfileAndPostOptionsSectionView extends StatelessWidget {
  const UserProfileAndPostOptionsSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileImageView(),
          const SizedBox(
            width: MARGIN_MEDIUM,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TitleText(
                title: "Pyi Theim Kyaw",
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
