import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_we_chat_app_by_my_self/blocs/start_page_bloc.dart';
import 'package:the_we_chat_app_by_my_self/pages/chat_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/contact_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/discover_page.dart';
import 'package:the_we_chat_app_by_my_self/pages/profile_page.dart';
import 'package:the_we_chat_app_by_my_self/rescources/colors.dart';
import 'package:the_we_chat_app_by_my_self/rescources/dimens.dart';
import 'package:the_we_chat_app_by_my_self/rescources/strings.dart';
import 'package:the_we_chat_app_by_my_self/view_items/icons_view.dart';

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
      const ChatPage(),
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
            appBar: (currentIndex == 3)
                ? null
                : AppBar(
                    elevation: 0,
                    backgroundColor: APP_BAR_COLOR,
                    centerTitle: true,
                    title: Text(
                      appBarTitles[currentIndex],
                      style: const TextStyle(color: Colors.black),
                    ),
                    actions: const [
                      SearchAndAddButtonView(),
                    ],
                  ),
            body: SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: pages[currentIndex])),
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
        height: MediaQuery.of(context).size.height / 12,
        indicatorColor: Colors.white,
      ),
      child: NavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        selectedIndex: selectedIndex,
        onDestinationSelected: (int newIndex) {
          onChangePageIndex(newIndex);
        },
        destinations: const [
          NavigationDestination(
              selectedIcon: Icon(
                Icons.chat_bubble,
                color: Colors.green,
              ),
              icon: Icon(
                Icons.chat_bubble_outline,
              ),
              label: LABEL_CHATS),
          NavigationDestination(
              icon: Icon(Icons.person_outline_outlined),
              selectedIcon: Icon(
                Icons.person,
                color: Colors.green,
              ),
              label: LABEL_CONTACTS),
          NavigationDestination(
              icon: Icon(Icons.search_sharp),
              selectedIcon: Icon(
                Icons.search_sharp,
                color: Colors.green,
              ),
              label: LABEL_DISCOVER),
          NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(
                Icons.person,
                color: Colors.green,
              ),
              label: LABEL_ME),
        ],
      ),
    );
  }
}
