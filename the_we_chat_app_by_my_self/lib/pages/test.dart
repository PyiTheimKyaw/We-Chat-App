import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/moments_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';

class MomentPage extends StatelessWidget {
  const MomentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MomentsPageBloc(),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: PRIMARY_COLOR,
          automaticallyImplyLeading: true,
          leadingWidth: 90,
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
                  style: TextStyle(
                      color: Colors.white60, fontSize: MARGIN_MEDIUM_2),
                ),
              ],
            ),
          ),
          title: const Text(LABEL_MOMENTS),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_outline_outlined),
            ),
          ],
        ),
        body: Container(
          color: Colors.white,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                const ChangeCoverPhotoSectionView(),
              ];
            },
            body: ListView.builder(
              padding: const EdgeInsets.symmetric(
                  vertical: MARGIN_XLARGE, horizontal: MARGIN_MEDIUM_2),
              itemCount: 40,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  margin: const EdgeInsets.only(top: MARGIN_LARGE),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Container(
                    height: null,
                    alignment: Alignment(1, 2),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(
                          "https://sm.askmen.com/t/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.1200.jpg"),
                      radius: 25,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ChangeCoverPhotoSectionView extends StatelessWidget {
  const ChangeCoverPhotoSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MomentsPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return SliverToBoxAdapter(
          child: GestureDetector(
            onTap: (bloc.chosenCoverImage == null)
                ? () async {
                    final ImagePicker _picker = ImagePicker();
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      bloc.onChosenCoverImage(File(image.path));
                    }
                  }
                : null,
            child: Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                color: Colors.black38,
                image: (bloc.chosenCoverImage != null)
                    ? DecorationImage(
                        image: FileImage(
                          bloc.chosenCoverImage ?? File(""),
                        ),
                        fit: BoxFit.cover)
                    : const DecorationImage(
                        image: NetworkImage(
                            "https://socialistmodernism.com/wp-content/uploads/2017/07/placeholder-image.png?w=640"),
                        fit: BoxFit.cover),
              ),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
                alignment: const Alignment(1.1, 1.4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    ProfileImageView(),
                    SizedBox(
                      width: 50,
                    ),
                    Flexible(
                      flex: 2,
                      child: UserNameAndMomentsInfoView(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class UserNameAndMomentsInfoView extends StatelessWidget {
  const UserNameAndMomentsInfoView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        Text(
          "Pyi Theim Kyaw ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Sunday September 14 , 2015 ",
          style: TextStyle(color: Colors.black, fontSize: TEXT_SMALL),
        ),
        Text(
          "23 new moments",
          style: TextStyle(color: Colors.black, fontSize: TEXT_SMALL),
        ),
      ],
    );
  }
}

class ProfileImageView extends StatelessWidget {
  const ProfileImageView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundImage: NetworkImage(
          "https://sm.askmen.com/t/askmen_in/article/f/facebook-p/facebook-profile-picture-affects-chances-of-gettin_fr3n.1200.jpg"),
      radius: 40,
    );
  }
}
