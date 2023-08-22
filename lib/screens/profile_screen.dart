import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/resources/firestore_methods.dart';
import 'package:flutter_insta_app/screens/edit_profile_screen.dart';
import 'package:flutter_insta_app/screens/post_show_screem.dart';
import 'package:flutter_insta_app/utiles/color.dart';
import 'package:flutter_insta_app/utiles/utile.dart';
import 'package:flutter_insta_app/widget/post_card.dart';
import 'package:page_transition/page_transition.dart';

import '../widget/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;

  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      //get post lenght
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: widget.uid,
          )
          .get();
      postLen = postSnap.docs.length;

      userData = userSnap.data()!;

      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;

      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      setState(() {});
    } catch (e) {
      showSnackBar(e.toString(), context, Colors.red, Colors.white);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor: mobileBackgroundColor,
              appBar: AppBar(
                backgroundColor: mobileBackgroundColor,
                title: Text(userData['userName']),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: size.width / 5,
                          height: size.width / 5,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(userData['photoUrl']),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: size.width / 9),
                              child: buildStateColumn(postLen, 'Posts', size),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: size.width / 20,
                                  left: size.width / 20),
                              child: buildStateColumn(
                                followers,
                                'Followers',
                                size,
                              ),
                            ),
                            buildStateColumn(
                              following,
                              'Following',
                              size,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: size.width / 27,
                            top: size.width / 25,
                          ),
                          child: Text(
                            userData['userName'],
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width / 25,
                            ),
                          ),
                        ),
                      ),
                      FirebaseAuth.instance.currentUser!.uid == widget.uid
                          ? Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width / 50),
                                child: FollowButton(
                                  text: 'Edit Profile',
                                  background: mobileBackgroundColor,
                                  textColor: Colors.white,
                                  borderColor: Colors.white,
                                  function: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                        type: PageTransitionType.bottomToTop,
                                        child: const EditProfileScreen(),
                                      ),
                                    );
                                  },
                                ),
                              ))
                          : isFollowing
                              ? Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width / 50),
                                    child: FollowButton(
                                      text: 'Unfollow',
                                      background: Colors.white,
                                      textColor: Colors.black,
                                      borderColor: Colors.grey,
                                      function: () async {
                                        await FireStoreMetods().followUser(
                                            FirebaseAuth.instance.currentUser!.uid, userData['uid']
                                        );
                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              : Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: size.width / 50),
                                    child: FollowButton(
                                      text: 'Follow',
                                      background: Colors.blue,
                                      textColor: Colors.white,
                                      borderColor: Colors.blue,
                                      function: () async {
                                        await FireStoreMetods().followUser(
                                            FirebaseAuth
                                                .instance.currentUser!.uid,
                                            userData['uid']);
                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                      const Divider(),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: size.height / 80, left: size.width / 27),
                    child: Text(
                      userData['bio'],
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width / 25),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height / 50),
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: widget.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.blue,
                              ),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 1.5,
                              childAspectRatio: 1,
                            ),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType.scale,
                                      alignment: Alignment.bottomCenter,
                                      child: ShowPostScreen(
                                        snap: snap.data(),
                                      ),
                                    ),
                                  );
                                },
                                child: Image(
                                  image: NetworkImage(snap['postUrl']),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Column buildStateColumn(int num, String label, Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: TextStyle(
            fontSize: size.width / 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: size.width / 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
