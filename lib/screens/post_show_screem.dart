import 'package:flutter/material.dart';
import 'package:flutter_insta_app/screens/profile_screen.dart';
import 'package:flutter_insta_app/utiles/color.dart';
import 'package:page_transition/page_transition.dart';

import '../widget/post_card.dart';

class ShowPostScreen extends StatefulWidget {
  final snap;

  const ShowPostScreen({Key? key, this.snap}) : super(key: key);

  @override
  State<ShowPostScreen> createState() => _ShowPostScreenState();
}

class _ShowPostScreenState extends State<ShowPostScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Back'),
          centerTitle: false,
          backgroundColor: mobileBackgroundColor,
        ),
        backgroundColor: mobileBackgroundColor,
        body: PostCard(
          onTapFunc: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: ProfileScreen(
                  uid: widget.snap['uid'],
                ),
              ),
            );
          },
          snap: widget.snap,
        ),
      ),
    );
  }
}
