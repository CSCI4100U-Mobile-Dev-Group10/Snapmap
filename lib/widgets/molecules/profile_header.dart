import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/widgets/atoms/avatar.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Avatar(user.profileURL),
        Column(
          children: [
            Text(user.username),
            Text(user.displayName),
          ],
        ),
      ],
    );
  }
}
