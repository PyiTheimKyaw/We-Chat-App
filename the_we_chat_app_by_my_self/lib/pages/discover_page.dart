import 'package:flutter/material.dart';
import 'package:the_we_chat_app_by_my_self/pages/moments_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/view_items/icons_view.dart';

import 'package:the_we_chat_app_by_my_self/utils/extensions.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DiscoverItemsListTileSectionView(
          title: LABEL_MOMENTS,
          onTapListTile: () {
            navigateToNextScreen(context, const MomentPage());
          },
        ),
        DiscoverItemsListTileSectionView(title: "Scan", onTapListTile: () {}),
        DiscoverItemsListTileSectionView(title: "Shake", onTapListTile: () {}),
        DiscoverItemsListTileSectionView(
            title: "Top Stories", onTapListTile: () {}),
      ],
    );
  }
}

class DiscoverItemsListTileSectionView extends StatelessWidget {
  DiscoverItemsListTileSectionView(
      {Key? key, required this.title, required this.onTapListTile})
      : super(key: key);
  String title;
  final Function onTapListTile;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTapListTile();
      },
      child: ListTile(
        leading: const Icon(Icons.color_lens),
        title: Row(
          children: [
            Text(title),
            const Spacer(),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
