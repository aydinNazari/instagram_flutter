import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
 // final String password;
  final String userName;
  final String bio;
  final String uid;
  final String photoUrl;
  final List followers;
  final List folloeing;


  const User({
    required this.email,
    required this.uid,
    required this.photoUrl,
    required this.userName,
    required this.bio,
    required this.followers,
    required this.folloeing,
   // required this.password
  });

  Map<String, Object> toJson() =>
      {
        "userName": userName,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl,
        "bio": bio,
        "followers": followers,
        "following": folloeing,
      //  "password": password,
      };


  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      uid: snapshot['uid'],
      photoUrl:snapshot['photoUrl'],
      userName: snapshot['userName'],
      bio: snapshot['bio'],
      followers: snapshot['followers'],
      folloeing: snapshot['following'],
     // password: snapshot['password'],
    );
  }

}