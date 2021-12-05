import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/widgets/atoms/avatar.dart';

class FriendListItem extends StatelessWidget {
  const FriendListItem(this.user, {Key? key}) : super(key: key);
  final User user;
  final String testPic =
      'https://firebasestorage.googleapis.com/v0/b/snapmap-46530.appspot.com/o/profile_test?alt=media&token=ae48bfa9-e791-4621-b7fb-73b2087644d0';
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Avatar(
          testPic,
          radi: 25,
        ),
        Column(
          children: const <Widget>[
            Text("Username"),
            SizedBox(height: 5),
            Text("Display Name")
          ],
        ),
        IconButton(
          onPressed: () {
            //Add delete friend functionality
          },
          icon: const Icon(Icons.delete),
          color: const Color(0xFF0EA47A),
          iconSize: 25,
        ),
      ],
    );
  }
}
