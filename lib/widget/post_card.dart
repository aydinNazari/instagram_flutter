import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/provider/user_provider.dart';
import 'package:flutter_insta_app/resources/firestore_methods.dart';
import 'package:flutter_insta_app/screens/comment_screen.dart';
import 'package:flutter_insta_app/utiles/utile.dart';
import 'package:flutter_insta_app/widget/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';
import '../screens/profile_screen.dart';

class PostCard extends StatefulWidget {
  final snap;
  final void Function()? onTapFunc;

  const PostCard({Key? key, this.snap, this.onTapFunc}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLengt = 0;

  @override
  void initState() {
    super.initState();
    setState(() {});
    getComment();
  }

  void getComment() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLengt = snapshot.docs.length;
      });
    } catch (e) {
      showSnackBar(e.toString(), context,Colors.red, Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).getUser;
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height / 1.3,
      child: Padding(
        padding: EdgeInsets.only(
          top: size.height / 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  right: size.width / 60,
                  left: size.width / 60,
                  bottom: size.height / 80),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.snap['ProfImg']),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: size.width / 50),
                    child: InkWell(
                      onTap: widget.onTapFunc,
                      child: Text(
                        widget.snap['userName'],
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          content: InkWell(
                            onTap: () async {
                              await FireStoreMetods()
                                  .deletePost(widget.snap['postId']);
                              setState(() {
                                Navigator.pop(context);
                              });
                            },
                            child: const Text(
                              'Delete',
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.more_vert_rounded,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onDoubleTap: () async {
                await FireStoreMetods().likePost(
                    widget.snap['postId'], user.uid, widget.snap['likes']);
                setState(() {
                  isLikeAnimating = !isLikeAnimating;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: size.width,
                    height: size.height / 2.5,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.snap['postUrl']),
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: isLikeAnimating ? 1 : 0,
                    child: LikeAnimation(
                      isAnimation: isLikeAnimating,
                      smallLike: false,
                      duration: const Duration(milliseconds: 400),
                      onEnd: () {
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      child: Icon(
                        Icons.favorite,
                        size: size.width / 3.5,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height / 60,
                  ),
                  child: SizedBox(
                    width: size.width / 3,
                    height: size.height / 25,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              await FireStoreMetods().likePost(
                                widget.snap['postId'],
                                user.uid,
                                widget.snap['likes'],
                              );
                              setState(
                                () {
                                  isLikeAnimating = !isLikeAnimating;
                                },
                              );
                            },
                            child: LikeAnimation(
                              isAnimation:
                                  widget.snap['likes'].contains(user.uid),
                              smallLike: true,
                              onEnd: () {},
                              child: Icon(
                                widget.snap['likes'].contains(user.uid)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                size: size.height / 25,
                                color: widget.snap['likes'].contains(user.uid)
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                  type: PageTransitionType.bottomToTop,
                                  child: CommentScreen(
                                    snap: widget.snap,
                                  ),
                                ),
                              );
                            },
                            child: Image.asset(
                              'assets/logo/comment_logo.png',
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/logo/direct_logo.png',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: Icon(
                    Icons.bookmark_border,
                    color: Colors.white,
                    size: size.height / 22,
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: size.width / 30, top: size.height / 80),
              child: Text(
                '${widget.snap['likes'].length} likes',
                style: TextStyle(
                  fontSize: size.width / 25,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: size.width / 30,
                top: size.height / 80,
              ),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.snap['userName'],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width / 25,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: '  ${widget.snap['description']}',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: size.width / 25,
                      ),
                    )
                  ],
                ),
              ),
            ),
            commentLengt != 0
                ? Padding(
                    padding: EdgeInsets.only(
                      left: size.width / 30,
                      top: size.height / 80,
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.bottomToTop,
                            child: CommentScreen(
                              snap: widget.snap,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'View all $commentLengt comments',
                        style: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(
                left: size.width / 30,
                top: size.height / 80,
              ),
              child: Text(
                DateFormat.yMMMd().format(
                  widget.snap['datePublish'].toDate(),
                ),
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: size.width / 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
