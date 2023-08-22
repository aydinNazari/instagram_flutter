import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/screens/profile_screen.dart';
import 'package:flutter_insta_app/utiles/color.dart';
import 'package:flutter_insta_app/widget/post_card.dart';
import 'package:page_transition/page_transition.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Container(
          width: size.width / 3,
          height: size.height / 10,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/logo/instagram_logo.png',
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding:
                EdgeInsets.only(right: size.width / 25, top: size.height / 50),
            child: Container(
              width: size.width / 14,
              height: size.height / 50,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/logo/direct_logo.png',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            );
          }
          return snapshot.data!.docs.isEmpty
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                )
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                    onTapFunc: () {
                      Navigator.push(
                        context,
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      );
                    },
                  ),
                );
        },
      ),
    );
  }
}
