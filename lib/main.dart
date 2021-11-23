// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:snapmap/screens/profile_creation.dart';
import 'screens/auth_screen.dart';
import 'screens/social_feed_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/profile_screen.dart';
import 'screens/camera_view_screen.dart';
import 'package:snapmap/widgets/organisms/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const SnapMap());
}

class SnapMap extends StatelessWidget {
  const SnapMap({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SnapMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SocialFeed(),
      routes: {
        '/authScreen': (context) => Authentication(),
        '/socialFeed': (context) => SocialFeed(),
        '/profileScreen': (context) => Profile(),
        '/cameraScreen': (context) => CameraView(),
        '/controller': (context) => NavController(),
        '/profileCreation': (context) => CreateProfile(),
      },
      initialRoute: '/authScreen',
    );
  }
}
