import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/screens/profile_creation_screen.dart';
import 'package:snapmap/widgets/atoms/avatar.dart';
import 'profile_display_name.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        // add space between icon header, username / display name and edit button
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Avatar(user.profileUrl),
          DisplayNameWidget(
              username: user.username, displayName: user.displayName),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(ProfileCreationScreen.routeId);
            },
            icon: const Icon(Icons.edit),
            iconSize: 30,
          )
        ],
      ),
    );
  }
}
