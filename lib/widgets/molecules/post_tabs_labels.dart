import 'package:flutter/material.dart';

class PostTabs extends StatelessWidget {
  const PostTabs({Key? key, required this.icon}) : super(key: key);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tab(child: Icon(icon, size: 20, color: const Color(0xFF12D39D)));
  }
}
