import 'package:flutter/material.dart';

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({Key? key, required this.icon}) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tab(child: Icon(icon, size: 30, color: Colors.blue));
  }
}
