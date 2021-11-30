import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';

class FriendCode extends StatelessWidget {
  const FriendCode(this.user, {Key? key}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Friend Code Here'));
  }
}
