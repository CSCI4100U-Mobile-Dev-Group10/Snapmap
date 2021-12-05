import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/utils/logger.dart';
import 'package:snapmap/widgets/atoms/dialog_base.dart';
import 'package:snapmap/widgets/molecules/profile_header.dart';

class FriendDeleteDialog extends StatelessWidget {
  const FriendDeleteDialog(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: ProfileHeader(
        user,
        showEdit: false,
      ),
      content: const Text('Are you sure you want to remove this friend?'),
      callback: () async {
        //what happens
        try {
          await UserService.getInstance().removeFriend(user.username);
        } catch (_) {
          logger.w('Friend was unsuccessfuly removed.');
        }
      },
    );
  }
}
