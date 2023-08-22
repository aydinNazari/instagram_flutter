import 'package:flutter/material.dart';
import 'package:flutter_insta_app/resources/auth_methods.dart';
import 'package:page_transition/page_transition.dart';


import '../widget/text_field_input.dart';
import 'log_in_screen.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String _email = '';
  bool control=false;
  bool ctrlVisibility=true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height/10,
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: size.width / 4,
                  right: size.width / 4,
                  top: size.height / 18,
                ),
                child: Container(
                  width: size.width / 5,
                  height: size.height / 5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'assets/logo/resetpass.png',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  bottom: size.height / 25,
                ),
                child: Text(
                  'Reset Passeord',
                  style: TextStyle(
                      fontSize: size.width / 19, fontWeight: FontWeight.w800),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: size.width / 18,
                  right: size.width / 18,
                ),
                child: TextFieldInput(
                  value: (s){
                    setState(() {
                      _email=s;
                      if (_email.contains('@') && _email.contains('.com')) {
                        control =true;
                      } else {
                       control=false;
                      }
                    });
                    setState(() {

                    });
                  },
                  size: size,
                  hintText: 'Enter your e-mail address...',
                  isPass: false,
                  textInputType: TextInputType.emailAddress, ctrlVisibility: ctrlVisibility,
                  iconOnPress: (){
                    setState(() {
                      ctrlVisibility = !ctrlVisibility;
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: size.height / 15),
                child: Container(
                  width: size.width / 3.5,
                  height: size.height / 15,
                  decoration:  BoxDecoration(
                    color: control ? const Color(0xff07B5FF) : const Color(
                        0xffbcbec2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () async {
                        if(control){
                          await AuthMethods().sendPasswordResetEmail(_email);
                      setState(() {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please check your e-mail',style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.white,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: const LoginScreen(),
                            isIos: true,
                          ),
                        );
                      });
                        }
                      },
                      child: Text(
                        'Send',
                        style: TextStyle(
                          fontSize: size.width / 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
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