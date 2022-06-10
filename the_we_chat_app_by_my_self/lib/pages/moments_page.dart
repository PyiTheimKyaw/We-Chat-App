import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/moments_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/pages/add_moment_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/view_items/profile_image_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';
import 'package:the_we_chat_app_by_my_self/widgets/commentOverLayView.dart';
import 'package:the_we_chat_app_by_my_self/widgets/flick_video_player.dart';
import 'package:the_we_chat_app_by_my_self/widgets/momentOverlayView.dart';

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
                  LABEL_DISCOVER,
                  style: TextStyle(
                      color: Colors.white60, fontSize: MARGIN_MEDIUM_2),
                ),
              ],
            ),
          ),
          title: TitleText(title: LABEL_MOMENTS),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                navigateToNextScreen(context, AddMomentPage());
              },
              icon: const Icon(Icons.camera_alt_outlined),
            ),
          ],
        ),
        body: Container(
          color: BACKGROUND_COLOR,
          // height: null,
          child: ListView(
            children: const [
              ChangeCoverPhotoSectionView(),
              MomentItemSectionView(),
            ],
          ),
        ),
      ),
    );
  }
}

class MomentItemSectionView extends StatelessWidget {
  const MomentItemSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MomentsPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            vertical: MARGIN_XLARGE * 2,
          ),
          itemCount: bloc.momentsList?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(top: MARGIN_MEDIUM_2),
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MomentOverlayView(moment: bloc.momentsList?[index]));
                    },
                    child: MomentsFavouriteAndCommentsView(
                      onTapDelete: (momentId) {
                        bloc.onTapDelete(momentId);
                      },
                      onTapEdit: (momentId) {
                        Future.delayed(Duration(seconds: 1)).then((value) {
                          navigateToNextScreen(
                              context,
                              AddMomentPage(
                                momentId: momentId,
                              ));
                        });
                      },
                      momentVO: bloc.momentsList?[index],
                    ),
                  ),
                  Positioned(
                    left: MOMENT_USER_PROFILE_HEIGHT / 2,
                    child: MomentUserProfileView(
                      userProfile: bloc.momentsList?[index].profilePicture,
                    ),
                  ),
                  const Positioned(
                    right: MOMENT_USER_PROFILE_HEIGHT / 2,
                    child: Text(
                      "12 mins ago",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class MomentUserProfileView extends StatelessWidget {
  MomentUserProfileView({
    Key? key,
    required this.userProfile,
  }) : super(key: key);
  String? userProfile;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(userProfile ?? ""),
      radius: MOMENT_USER_PROFILE_HEIGHT / 2,
    );
  }
}

class MomentsFavouriteAndCommentsView extends StatelessWidget {
  MomentsFavouriteAndCommentsView({
    Key? key,
    required this.momentVO,
    required this.onTapDelete,
    required this.onTapEdit,
  }) : super(key: key);
  final MomentVO? momentVO;
  final Function(int) onTapDelete;
  final Function(int) onTapEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MomentsItemView(
          onTapDelete: () {
            onTapDelete(momentVO?.id ?? 0);
          },
          onTapEdit: () {
            onTapEdit(momentVO?.id ?? 0);
          },
          moment: momentVO,
        ),
        const SizedBox(
          height: 4,
        ),
        const CommentsAndFavouriteView(),
      ],
    );
  }
}

class CommentsAndFavouriteView extends StatelessWidget {
  const CommentsAndFavouriteView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
          left: MARGIN_XLARGE * 2, right: MARGIN_XLARGE, top: MARGIN_MEDIUM_2),
      height: 300,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -7.0), //(x,y)
            blurRadius: 8.0,
          ),
        ],
        color: BACKGROUND_COLOR,
      ),
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              FavouriteView(),
              SizedBox(
                height: MARGIN_SMALL,
              ),
              CommentView(),
            ],
          );
        },
      ),
    );
  }
}

class CommentView extends StatelessWidget {
  const CommentView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.comment,
          size: TEXT_REGULAR,
        ),
        const SizedBox(
          width: MARGIN_SMALL,
        ),
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: 30,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: MARGIN_MEDIUM),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: const <TextSpan>[
                      TextSpan(
                          text: 'Davies',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text:
                              'I like this post I like this post I like this post I like this post I like this post !',
                          style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FavouriteView extends StatelessWidget {
  const FavouriteView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Icon(
          Icons.favorite,
          size: TEXT_REGULAR,
        ),
        SizedBox(
          width: MARGIN_SMALL,
        ),
        Expanded(
            child: Text(
          "Steves,Davies,John,Jones,Steves,Davies,John,Jones,Steves,Davies,John,Jones, ",
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
      ],
    );
  }
}

class MomentsItemView extends StatelessWidget {
  MomentsItemView({
    Key? key,
    required this.moment,
    required this.onTapDelete,
    required this.onTapEdit,
    this.isOverlay=false,
    this.color=Colors.black,
  }) : super(key: key);
  final MomentVO? moment;
  final Function onTapDelete;
  final Function onTapEdit;
  final bool isOverlay;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: post,
      margin: const EdgeInsets.only(top: MARGIN_LARGE),
      decoration:  BoxDecoration(
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.grey,
        //     offset: Offset(0.0, 1.0), //(x,y)
        //     blurRadius: 6.0,
        //   ),
        // ],
        color: (isOverlay) ? Colors.transparent:Colors.white,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: MARGIN_MEDIUM_2, vertical: MARGIN_SMALL),
        height: null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.only(left: (isOverlay) ? MARGIN_SMALL:PROFILE_HEIGHT),
              child: TitleText(
                title: moment?.userName ?? "",
                textColor: color,
              ),
            ),
            Padding(
              padding:  EdgeInsets.only(
                  left: (isOverlay) ? MARGIN_SMALL:MARGIN_LARGE, top: MARGIN_MEDIUM, bottom: MARGIN_LARGE),
              child: Text(moment?.description ?? "",style: TextStyle(color: color),),
            ),
            MomentImageView(
              fileType: moment?.fileType ?? "",
              momentImage: moment?.postFile,
            ),
            const SizedBox(
              height: MARGIN_SMALL,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                 Icon(Icons.favorite_border,color: color,),
                const SizedBox(
                  width: MARGIN_SMALL,
                ),
                 CommentButtonView(color: color,),
                const SizedBox(
                  width: MARGIN_SMALL,
                ),
                MoreButtonView(
                  onTapEdit: onTapEdit,
                  onTapDelete: onTapDelete,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CommentButtonView extends StatelessWidget {
   CommentButtonView({
    Key? key,
    required this.color,
  }) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon:  Icon(Icons.comment_outlined,color: color,),
      onPressed: () {
        print("comment print");
        Navigator.of(context).push(CommentOverlayView());
      },
    );
  }
}

class MoreButtonView extends StatelessWidget {
  MoreButtonView({
    Key? key,
    required this.onTapDelete,
    required this.onTapEdit,
  }) : super(key: key);
  final Function onTapDelete;
  final Function onTapEdit;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (BuildContext context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            onTapEdit();
          },
          child: const Text("Edit"),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () {
            onTapDelete();
          },
          child: const Text("Delete"),
        ),
      ],
      child: const Icon(
        Icons.more_horiz_outlined,
        color: Colors.grey,
      ),
    );
  }
}

class MomentImageView extends StatelessWidget {
  MomentImageView({
    Key? key,
    required this.momentImage,
    required this.fileType,
  }) : super(key: key);
  String? momentImage;
  String fileType;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: momentImage != "",
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: double.infinity,
        height: MOMENT_IMAGE_HEIGHT,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MARGIN_SMALL),
        ),
        child: (fileType == "mp4")
            ? FLickVideoPlayerView(
                isMomentsPage: true,
                momentFile: momentImage,
              )
            : Image.network(
                momentImage ?? "",
                fit: BoxFit.cover,
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
    final top = MediaQuery.of(context).size.height / 3 - PROFILE_HEIGHT / 2;
    const left = PROFILE_HEIGHT / 1.5;
    return Consumer<MomentsPageBloc>(
      builder: (BuildContext context, bloc, Widget? child) {
        return GestureDetector(
          onTap: (bloc.chosenCoverImage == null)
              ? () async {
                  final ImagePicker picker = ImagePicker();
                  final XFile? image =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    bloc.onChosenCoverImage(File(image.path));
                  }
                }
              : null,
          child: Stack(
            // alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Container(
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
              ),
              Positioned(
                top: top,
                left: left,
                child: const ProfileImageAndUserNameSectionView(),
              )
            ],
          ),
        );
      },
    );
  }
}

class ProfileImageAndUserNameSectionView extends StatelessWidget {
  const ProfileImageAndUserNameSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: MARGIN_MEDIUM_2),
      // alignment: const Alignment(2, 0),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
              flex: 3,
              child: ProfileImageView(
                radius: PROFILE_HEIGHT / 2,
              )),
          const SizedBox(
            width: PROFILE_HEIGHT,
          ),
          const Flexible(
            flex: 1,
            child: UserNameAndMomentsInfoView(),
          ),
        ],
      ),
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
      // mainAxisAlignment: MainAxisAlignment.center,
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
