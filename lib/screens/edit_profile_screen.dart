import 'package:flutter/material.dart';
import 'package:flutter_insta_app/resources/auth_methods.dart';
import 'package:flutter_insta_app/screens/log_in_screen.dart';
import 'package:flutter_insta_app/utiles/color.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(
            'Edit profile',
            style: TextStyle(
              fontSize: size.width / 20,
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: size.width / 22,
                top: size.height / 25,
              ),
              child: InkWell(
                onTap: () {
                  showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: const Text('Are you sure you want to log out'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            await AuthMethods().signOut();
                            setState(
                              () {
                                Navigator.of(context).pop();
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder:(BuildContext context)=>LoginScreen()),
                                      (route)=>route.isFirst,
                                );

                              },
                            );
                          },
                          child: const Text('Yes'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('No'),
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width / 22,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
