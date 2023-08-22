import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/resources/auth_methods.dart';
import 'package:flutter_insta_app/screens/forget_pass_screen.dart';
import 'package:flutter_insta_app/screens/sign_up_screen.dart';
import 'package:page_transition/page_transition.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layaout.dart';
import '../widget/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String pass;
  bool _isLoading = false;
  bool ctrlVisibility = true;
  bool control = false;

  Future<void> logInUser() async {
    if (control) {
      setState(() {
        _isLoading = true;
      });
      String res = await AuthMethods()
          .loginUser(email: email, pass: pass, context: context);
      setState(() {
        _isLoading = false;
      });
      if (res == 'success') {
        setState(
          () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>  ResponsiveLayout(
                  mobileScreenLayout: const MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                ),
              ),
            );
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: size.width / 5,
                  right: size.width / 5,
                  top: size.height / 8,
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
              Padding(
                padding: EdgeInsets.only(
                  left: size.width / 25,
                  top: size.height / 20,
                  right: size.width / 25,
                ),
                child: TextFieldInput(
                  ctrlVisibility: false,
                  value: (s) {
                    setState(() {
                      email = s;
                      if (email.contains('@') && email.contains('.com')) {
                        control = true;
                      } else {
                        control = false;
                      }
                    });
                  },
                  size: size,
                  hintText: 'Enter your e-mail address...',
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
                  ctrlVisibility: ctrlVisibility,
                  iconOnPress: () {
                    setState(() {
                      ctrlVisibility = !ctrlVisibility;
                    });
                  },
                  value: (s) {
                    pass = s;
                  },
                  size: size,
                  textInputType: TextInputType.visiblePassword,
                  hintText: 'Enter your Password',
                  isPass: true,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: size.width / 1.7,
                  top: size.height / 50,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageTransition(
                        type: PageTransitionType.rightToLeft,
                        child: const ForgotPasswordPage(),
                        isIos: true,
                      ),
                    );
                  },
                  child: Text(
                    'Forget password?',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: size.width / 25,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: size.height / 20,
                ),
                child: InkWell(
                  onTap: logInUser,
                  child: Container(
                    width: size.width / 2.5,
                    height: size.height / 15,
                    decoration: BoxDecoration(
                      color: control ? Colors.blue : const Color(0xffe6e9ec),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                          size.width / 25,
                        ),
                      ),
                    ),
                    child: Center(
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Log In',
                              style: TextStyle(
                                color: control
                                    ? Colors.white
                                    : const Color(0xff3d3a3a),
                                fontSize: size.width / 22,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height / 6),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don\'t have an account? ',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ),
                            );
                          },
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        text: ' Sign up',
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
