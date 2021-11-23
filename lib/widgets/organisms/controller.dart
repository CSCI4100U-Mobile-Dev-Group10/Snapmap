// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// This file controls the switch between social feed screen, camera view and profile screen
// it dosent allow for back button to work with will pop scope

import 'package:flutter/material.dart';
import 'package:snapmap/screens/profile_screen.dart';
import 'package:snapmap/screens/social_feed_screen.dart';
import 'package:snapmap/screens/camera_view_screen.dart';

class NavController extends StatefulWidget {
  const NavController({Key? key}) : super(key: key);

  @override
  _NavControllerState createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  var selectedIndex = 0;
  var pages = [SocialFeed(), CameraView(), Profile()];

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: selectedIndex,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.shifting,
          iconSize: 30,
          selectedIconTheme: IconThemeData(
            color: Colors.blue,
            size: 40,
          ),
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.photo_library),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: '',
            )
          ],
        ),
      ),
    );
  }
}