import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/provider/user_provider.dart';
import 'package:flutter_insta_app/responsive/mobile_screen_layout.dart';
import 'package:flutter_insta_app/responsive/responsive_layout_screen.dart';
import 'package:flutter_insta_app/responsive/web_screen_layaout.dart';
import 'package:flutter_insta_app/screens/log_in_screen.dart';
import 'package:flutter_insta_app/utiles/color.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyC8uyltjh0NS5kr_mzkP-1MZ3EEHOI0k4w',
          appId: '1:1043428427401:web:fdaa6ce1067d47c5c42858',
          messagingSenderId: '1043428427401',
          projectId: 'instagramdemo-903de',
          storageBucket: 'instagramdemo-903de.appspot.com'),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Instagram demo',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return  Scaffold(
                  body: ResponsiveLayout(
                    mobileScreenLayout: const MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
