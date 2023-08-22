import 'package:flutter/material.dart';
import 'package:flutter_insta_app/provider/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../model/user.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //User user=Provider.of<UserProvider>(context).getUser;
    return Padding(
      padding: EdgeInsets.only(top: size.height / 25, left: size.width / 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           CircleAvatar(
            backgroundImage: NetworkImage(
              snap['profilePic']
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: size.width / 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: snap['name'],
                          style: TextStyle(
                            fontSize: size.width / 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        TextSpan(
                          text: ' ${snap['text']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                            fontSize: size.width / 30,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: size.height / 120,
                    ),
                    child: Text(
                      DateFormat.yMMMd().format(snap['datePublished'].toDate()),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade500,
                        fontSize: size.width / 30,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: size.width / 20),
            child: InkWell(
              onTap: (){
                
              },
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: size.width / 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}
