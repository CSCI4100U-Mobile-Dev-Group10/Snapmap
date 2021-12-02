// This file controls the switch between social feed screen, camera view and profile screen
// it dosent allow for back button to work with will pop scope

import 'package:flutter/material.dart';
import 'package:snapmap/screens/profile_screen.dart';
import 'package:snapmap/screens/social_feed_screen.dart';
import 'package:snapmap/screens/camera_view_screen.dart';
import 'package:snapmap/screens/map_screen.dart';

class NavController extends StatefulWidget {
  static const String routeId = '/nav_controller';
  const NavController({Key? key}) : super(key: key);

  @override
  _NavControllerState createState() => _NavControllerState();
}

class _NavControllerState extends State<NavController> {
  var selectedIndex = 0;
  var pages = [
    const SocialFeedScreen(),
    const CameraViewScreen(),
    const ProfileScreen(),
    // const MapScreen()
  ];

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
          selectedIconTheme: const IconThemeData(
            color: Color(0xFF0EA47A),
            size: 40,
          ),
          selectedItemColor: const Color(0xFF0EA47A),
          unselectedItemColor: const Color(0xFF12D39D),
          items: const [
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
            ),
            //test Section to verfy map is working
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.map),
            //   label: '',
            // ),
          ],
        ),
      ),
    );
  }
}
