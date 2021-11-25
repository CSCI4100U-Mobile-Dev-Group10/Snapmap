import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';

class FriendsList extends StatelessWidget {
  const FriendsList(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return const Text('friends list');
  }
}
