import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/model/user.dart' as model;
import 'package:flutter_insta_app/resources/strorage_methods.dart';
import 'package:flutter_insta_app/utiles/utile.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String userName,
      required String bio,
      required Uint8List file,
      required BuildContext context}) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        print(cred.user!.uid);
        String photoUrl = await StorageMethods()
            .uploadImageToStringe('profilePics', file, false);
        model.User user = model.User(
            userName: userName,
            email: email,
            bio: bio,
            // password: password,
            photoUrl: photoUrl,
            uid: cred.user!.uid,
            folloeing: [],
            followers: []);
        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalide-email') {
        res = 'The email is badly formatted';
      } else if (err.code == 'weak-password') {
        res = 'Password should be at least 6 charakters';
      }
      showSnackBar(res, context,Colors.red, Colors.white);
    } catch (err) {
      res = err.toString();
      showSnackBar(res, context,Colors.red, Colors.white);
    }
    return res;
  }

  Future<String> loginUser(
      {required String email,
      required String pass,
      required BuildContext context}) async {
    String res = 'Some error occurred';
    try {
      if (email.isNotEmpty || pass.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: pass);
        res = 'success';
      } else {
        res = 'Please enter the all fields';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showSnackBar('User not found!', context, Colors.red, Colors.white);
      } else if (e.code == 'wrong-password') {
        showSnackBar('Wrong password!', context,Colors.red, Colors.white);
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
