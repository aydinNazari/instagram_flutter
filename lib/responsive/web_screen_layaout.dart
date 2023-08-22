import 'package:flutter/material.dart';
import 'package:flutter_insta_app/utiles/color.dart';

import '../utiles/global_variables.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  late PageController pageController;
  int _page = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    pageController = PageController();
    super.initState();
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
    Size size = MediaQuery.of(context).size;
    print(size.width);
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: const Color(0xff1c2426),
            // NavigationRail içerisinde navigasyon seçeneklerini belirleyebilirsiniz.
            destinations: [
              /*   NavigationRailDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 40),
                  child: Container(
                    width: size.width > 900 ? 36 : size.width / 25,
                    height: size.width > 900 ? 36 : size.width / 25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/logo/insta_icon_logo.png',
                        ),
                      ),
                    ),
                  ),
                ),
                label: const Text('Insta'),
              ),*/
              NavigationRailDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Icon(
                    Icons.home,
                    size: size.width > 900 ? 36 : size.width / 25,
                  ),
                ),
                label: const Text('Home'),
              ),
              NavigationRailDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Icon(Icons.search,
                      size: size.width > 900 ? 36 : size.width / 25),
                ),
                label: const Text('Search'),
              ),
              NavigationRailDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Icon(Icons.add_circle,
                      size: size.width > 900 ? 36 : size.width / 25),
                ),
                label: const Text('Add'),
              ),
              NavigationRailDestination(
                icon: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Icon(Icons.favorite,
                      size: size.width > 900 ? 36 : size.width / 25),
                ),
                label: const Text('Notification'),
              ),
              NavigationRailDestination(
                icon: SizedBox(
                  width: size.width > 900 ? 36 : size.width / 25,
                  height: size.width > 900 ? 36 : size.width / 25,
                  child: const CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1680833929488-575890a7f8b5?ixlib=rb-4.0.3&ix'
                      'id=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=687&q=80',
                    ),
                  ),
                ),
                label: const Text('Profile'),
              ),
            ],
            selectedIndex: 0,
            onDestinationSelected: navigationTapped,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              children: homeScreenItem,
            ),
          ),
        ],
      ),
    );
  }
}
