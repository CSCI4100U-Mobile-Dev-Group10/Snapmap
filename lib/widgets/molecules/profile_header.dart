import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/screens/profile_creation_screen.dart';
import 'package:snapmap/widgets/atoms/avatar.dart';
import 'profile_display_name.dart';

class ProfileHeader extends StatefulWidget {
  const ProfileHeader(this.user,
      {this.showEdit = true, this.avatarSize, Key? key})
      : super(key: key);
  final User user;
  final bool showEdit;
  final double? avatarSize;
  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final users = FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        // add space between icon header, username / display name and edit button
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Avatar(widget.user.profileUrl),
          DisplayNameWidget(
              username: widget.user.username,
              displayName: widget.user.displayName),
          if (widget.showEdit)
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
