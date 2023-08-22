import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  // final String password;
  final String uid;
  final String userName;
  final String postId;
  final datePublish;
  final String postUrl;
  final String profImg;
  final likes;


  const Post({
    required this.description,
    required this.uid,
    required this.userName,
    required this.postId,
    required this.datePublish,
    required this.postUrl,
    required this.profImg,
    required this.likes
    // required this.password
  });

  Map<String, Object> toJson() =>
      {
        "description": description,
        "uid": uid,
        "userName": userName,
        "postId": postId,
        "datePublish": datePublish,
        "postUrl": postUrl,
        "ProfImg": profImg,
        "likes": likes,
        //  "password": password,
      };


  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      userName: snapshot['userName'],
      postId:snapshot['postId'],
      datePublish: snapshot['datePublish'],
      postUrl: snapshot['postUrl'],
      profImg: snapshot['profImg'],
      likes: snapshot['likes'],

      // password: snapshot['password'],
    );
  }

}