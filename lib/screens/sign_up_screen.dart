import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_insta_app/resources/auth_methods.dart';
import 'package:flutter_insta_app/utiles/utile.dart';
import 'package:flutter_insta_app/widget/text_field_input.dart';
import 'package:image_picker/image_picker.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layaout.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _email = '';
  String _password = '';
  String _userName = '';
  String _bio = '';
  bool ctrlVisibility = true;
  Uint8List? _image;
  bool isLoading = false;

  Future<void> selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  Future<void> signUpUser() async {
    if (_userName != '' &&
        _email != '' &&
        _password != '' &&
        _bio != '' &&
        _image != null) {
      setState(() {
        isLoading = true;
      });
      String res = await AuthMethods().signUpUser(
          email: _email,
          password: _password,
          userName: _userName,
          bio: _bio,
          file: _image!,
          context: context);
      setState(() {
        isLoading = false;
      });
      if (res != 'success') {
        setState(() {
          showSnackBar(
            res,
            context,
            Colors.white,
            Colors.black,
          );
        });
      } else {
        setState(() {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>  ResponsiveLayout(
              mobileScreenLayout: const MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            ),
          ));
        });
      }
    } else {
      showSnackBar(
          'please fill in all fields', context, Colors.red, Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: size.width / 5,
                right: size.width / 5,
              ),
              child: Container(
                width: size.width,
                height: size.height / 4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/logo/instagram_logo.png',
                    ),
                  ),
                ),
              ),
            ),
            _image == null
                ? Stack(
                    children: [
                      Container(
                        width: size.width / 3.5,
                        height: size.width / 3.5,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white10,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            size: size.width / 5,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: size.height / 80,
                        right: 0,
                        child: Container(
                          width: size.width / 14,
                          height: size.width / 14,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: InkWell(
                            onTap: selectImage,
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : Container(
                    width: size.width / 3.5,
                    height: size.width / 3.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white10,
                      image: DecorationImage(
                        image: Image.memory(_image!).image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width / 25,
                    top: size.height / 20,
                    right: size.width / 25,
                  ),
                  child: TextFieldInput(
                    ctrlVisibility: false,
                    iconOnPress: null,
                    value: (value) {
                      _userName = value;
                    },
                    size: size,
                    hintText: 'Enter your user name',
                    isPass: false,
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width / 25,
                    top: size.height / 40,
                    right: size.width / 25,
                  ),
                  child: TextFieldInput(
                    ctrlVisibility: false,
                    iconOnPress: () {},
                    value: (value) {
                      _email = value;
                    },
                    size: size,
                    textInputType: TextInputType.visiblePassword,
                    hintText: 'Enter your email',
                    isPass: false,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width / 25,
                    top: size.height / 40,
                    right: size.width / 25,
                  ),
                  child: TextFieldInput(
                    ctrlVisibility: ctrlVisibility,
                    iconOnPress: () {
                      setState(() {
                        ctrlVisibility = !ctrlVisibility;
                      });
                    },
                    value: (value) {
                      _password = value;
                    },
                    size: size,
                    hintText: 'Enter your password',
                    isPass: true,
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: size.width / 25,
                    top: size.height / 40,
                    right: size.width / 25,
                  ),
                  child: TextFieldInput(
                    ctrlVisibility: false,
                    value: (value) {
                      _bio = value;
                    },
                    size: size,
                    hintText: 'Enter your bio',
                    isPass: false,
                    textInputType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: size.height / 20,
                    left: size.width / 25,
                    right: size.width / 25,
                  ),
                  child: InkWell(
                    onTap: signUpUser,
                    child: Container(
                      width: size.width,
                      height: size.height / 15,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(
                          Radius.circular(size.width / 50),
                        ),
                      ),
                      child: Center(
                        child: isLoading == false
                            ? Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width / 22,
                                ),
                              )
                            : const CircularProgressIndicator(
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
