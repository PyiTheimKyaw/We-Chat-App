import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/start_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/pages/chat_list_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/contact_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/discover_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/profile_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/view_items/icons_view.dart';
import 'package:the_we_chat_app_by_my_self/view_items/title_text.dart';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> appBarTitles = [
      LABEL_WECHAT,
      LABEL_CONTACTS,
      LABEL_DISCOVER,
    ];
    List<Widget> pages = [
      const ChatListPage(),
      const ContactPage(),
      const DiscoverPage(),
      const ProfilePage()
    ];
    return ChangeNotifierProvider(
      create: (BuildContext context) => StartPageBloc(),
      child: Selector<StartPageBloc, int>(
        selector: (context, bloc) => bloc.currentIndex,
        builder: (BuildContext context, currentIndex, Widget? child) {
          return Scaffold(
            body: Container(
                // height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: pages[currentIndex]),
            bottomNavigationBar: NavigationBarSectionView(
              onChangePageIndex: (pageIndex) {
                StartPageBloc bloc = Provider.of(context, listen: false);
                bloc.onChangePageIndex(pageIndex);
              },
              selectedIndex: currentIndex,
            ),
          );
        },
      ),
    );
  }
}

class NavigationBarSectionView extends StatelessWidget {
  const NavigationBarSectionView({
    Key? key,
    required this.onChangePageIndex,
    required this.selectedIndex,
  }) : super(key: key);
  final Function(int) onChangePageIndex;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        height: MediaQuery.of(context).size.height / 15,
        indicatorColor: BOTTOM_NAVIGATION_BOTTOM_COLOR,
      ),
      child: NavigationBar(
        backgroundColor: BOTTOM_NAVIGATION_BOTTOM_COLOR,
        elevation: 0,
        selectedIndex: selectedIndex,
        onDestinationSelected: (int newIndex) {
          onChangePageIndex(newIndex);
        },
        destinations: const [
          NavigationDestination(
              selectedIcon: Icon(
                Icons.wechat_outlined,
                color: PRIMARY_COLOR,
              ),
              icon: Icon(
                Icons.wechat_outlined,
                  color: Colors.black54
              ),
              label: LABEL_CHATS),
          NavigationDestination(
              icon: Icon(Icons.contact_page_outlined,color: Colors.black54,),
              selectedIcon: Icon(
                Icons.contact_page,
                color: PRIMARY_COLOR,
              ),
              label: LABEL_CONTACTS),
          NavigationDestination(
              icon: Icon(Icons.search_sharp,color: Colors.black54),
              selectedIcon: Icon(
                Icons.search_sharp,
                color: PRIMARY_COLOR,
              ),
              label: LABEL_DISCOVER),
          NavigationDestination(
              icon: Icon(Icons.person_outline,color: Colors.black54),
              selectedIcon: Icon(
                Icons.person,
                color: PRIMARY_COLOR,
              ),
              label: LABEL_ME),
        ],
      ),
    );
  }
}
