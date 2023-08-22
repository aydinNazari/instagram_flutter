import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/resources/firestore_methods.dart';
import 'package:flutter_insta_app/utiles/color.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../provider/user_provider.dart';
import '../widget/comment_card.dart';

class CommentScreen extends StatefulWidget {
  final snap;

  const CommentScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  TextEditingController commentText = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: mobileBackgroundColor,
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: const Text('Comment'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.snap['postId'])
              .collection('comments')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context, index) => CommentCard(
                snap: (snapshot.data! as dynamic).docs[index],
              ),
            );
          },
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            height: kToolbarHeight,
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: size.width / 20,
                right: size.width / 25,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(
                      user.photoUrl,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: size.width / 40,
                        right: size.width / 50,
                      ),
                      child: TextField(
                        controller: commentText,
                        decoration: InputDecoration(
                          hintText: 'comment as ${user.userName}',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await FireStoreMetods().postComment(
                        widget.snap['postId'],
                        commentText.text,
                        user.uid,
                        user.userName,
                        user.photoUrl,
                      );
                      setState(() {
                        commentText.clear();
                      });
                    },
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: size.width / 22,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
