import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/screens/post_show_screem.dart';
import 'package:flutter_insta_app/screens/profile_screen.dart';
import 'package:flutter_insta_app/utiles/color.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:page_transition/page_transition.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  bool isShowUser = false;

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: TextField(
            onChanged: (String _) {
              setState(() {
                if (_ != '') {
                  isShowUser = true;
                } else {
                  isShowUser = false;
                }
              });
            },
            controller: searchController,
            decoration: const InputDecoration(
              border: InputBorder.none,
              labelText: 'Search as a user',
            ),
          ),
        ),
        body: isShowUser
            ? FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'userName',
                      isGreaterThanOrEqualTo: searchController.text,
                    )
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ProfileScreen(
                                uid: (snapshot.data! as dynamic).docs[index]
                                    ['uid'],
                              ),
                            ),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['photoUrl'],
                            ),
                          ),
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['userName'],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.blue,
                      ),
                    );
                  }
                  return MasonryGridView.builder(
                    crossAxisSpacing: 3,
                    mainAxisSpacing: 3,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.scale,
                            alignment: Alignment.bottomCenter,
                            child: ShowPostScreen(
                              snap: (snapshot.data! as dynamic).docs[index],
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        (snapshot.data! as dynamic).docs[index]['postUrl'],
                      ),
                    ),
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:
                          (snapshot.data! as dynamic).docs.length > 10 ? 3 : 2,
                    ),
                  );
                },
              ),
      ),
    );
  }
}
