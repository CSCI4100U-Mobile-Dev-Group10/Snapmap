// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/social_feed_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      home: socialFeed(),
      routes: {
        '/authScreen': (context) => authentication(),
        '/socialFeed': (context) => socialFeed(),
      },
      initialRoute: '/authScreen',
    );
  }
}
