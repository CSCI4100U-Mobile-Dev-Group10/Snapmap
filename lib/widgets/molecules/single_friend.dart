import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/widgets/atoms/avatar.dart';
import 'package:snapmap/widgets/organisms/friend_delete_dialog.dart';

class FriendListItem extends StatelessWidget {
  const FriendListItem(this.user, {Key? key}) : super(key: key);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Avatar(
          user.profileUrl,
          radi: 25,
        ),
        Column(
          children: <Widget>[
            Text(user.displayName),
            const SizedBox(height: 5),
            Text('@' + user.username)
          ],
        ),
        IconButton(
          onPressed: () {
            //Add delete friend functionality
            showDialog(
                context: context, builder: (_) => FriendDeleteDialog(user));
          },
          icon: const Icon(Icons.delete),
          color: const Color(0xFF0EA47A),
          iconSize: 25,
        ),
      ],
    );
  }
}
