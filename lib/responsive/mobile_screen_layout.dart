import 'package:flutter/material.dart';
import 'package:flutter_insta_app/utiles/color.dart';

import '../utiles/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItem,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: size.width/12,
              color: _page == 0 ? primaryColor : secendaryColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: size.width/12,
                color: _page == 1 ? primaryColor : secendaryColor,
              ),
              label: 'Search',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_circle,
                size: size.width/12,
                color: _page == 2 ? primaryColor : secendaryColor,
              ),
              label: 'Add',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: size.width/12,
                color: _page == 3 ? primaryColor : secendaryColor,
              ),
              label: 'Favori',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: size.width/12,
                color: _page == 4 ? primaryColor : secendaryColor,
              ),
              label: 'Person',
              backgroundColor: primaryColor)
        ],
        onTap: navigationTapped,
      ),
    );
  }
}
