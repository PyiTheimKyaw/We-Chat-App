import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/moments_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/data/vos/moment_vo.dart';
import 'package:the_we_chat_app_by_my_self/pages/add_moment_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';
import 'package:the_we_chat_app_by_my_self/utils/time_ago.dart';
import 'package:the_we_chat_app_by_my_self/view_items/moment_item_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/profile_image_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';
import 'package:the_we_chat_app_by_my_self/widgets/momentOverlayView.dart';

class MomentPage extends StatelessWidget {
  const MomentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => MomentsPageBloc(),
      child: Scaffold(
        appBar: buildAppBar(context),
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

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: PRIMARY_COLOR,
      // automaticallyImplyLeading: true,
      leadingWidth: MediaQuery.of(context).size.width / 4,
      // leading: GestureDetector(
      //   onTap: () {
      //     Navigator.pop(context);
      //   },
      //   child: Row(
      //     children: const [
      //       Icon(
      //         Icons.chevron_left,
      //         size: TEXT_LARGE,
      //       ),
      //       Text(
      //         LABEL_DISCOVER,
      //         style: TextStyle(
      //             color: Colors.white60, fontSize: MARGIN_MEDIUM_2),
      //       ),
      //     ],
      //   ),
      // ),
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
                        Future.delayed(const Duration(seconds: 1))
                            .then((value) {
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
                  Positioned(
                    right: MOMENT_USER_PROFILE_HEIGHT / 2,
                    child: Text(
                      TimeAgo.timeAgoSinceDateNow(bloc.momentsList?[index].timeStamp ?? 0),
                      style: const TextStyle(color: Colors.black54),
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
  const MomentUserProfileView({
    Key? key,
    required this.userProfile,
  }) : super(key: key);
  final String? userProfile;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: NetworkImage(userProfile ??
          "https://th.bing.com/th/id/OIP.TpqSE-tsrMBbQurUw2Su-AHaHk?pid=ImgDet&rs=1"),
      radius: MOMENT_USER_PROFILE_HEIGHT / 2,
    );
  }
}

class MomentsFavouriteAndCommentsView extends StatelessWidget {
  const MomentsFavouriteAndCommentsView({
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
                child: ProfileImageAndUserNameSectionView(
                  profilePicture: bloc.loggedInUser?.profilePicture ?? "",
                  userName: bloc.loggedInUser?.userName ?? "",
                ),
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
    required this.profilePicture,
    required this.userName,
  }) : super(key: key);
  final String profilePicture;
  final String userName;

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
                profilePicture: profilePicture,
              )),
           SizedBox(
            width: MediaQuery.of(context).size.width/3,
          ),
          Flexible(
            flex: 2,
            child: UserNameAndMomentsInfoView(
              userName: userName,
            ),
          ),
        ],
      ),
    );
  }
}

class UserNameAndMomentsInfoView extends StatelessWidget {
  const UserNameAndMomentsInfoView({
    Key? key,
    required this.userName,
  }) : super(key: key);
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          userName,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 20,
        ),
         Text(
          DateFormat("MMMM, dd, yyyy").format(DateTime.now()),
          style: TextStyle(color: Colors.black, fontSize: TEXT_SMALL),
        ),
        const Text(
          "23 new moments",
          style: TextStyle(color: Colors.black, fontSize: TEXT_SMALL),
        ),
      ],
    );
  }
}
