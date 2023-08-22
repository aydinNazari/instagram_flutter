import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/screens/add_post_screen.dart';
import 'package:flutter_insta_app/screens/feed_screen.dart';
import 'package:flutter_insta_app/screens/profile_screen.dart';
import 'package:flutter_insta_app/screens/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItem = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(
    child: Text('favori'),
  ),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
