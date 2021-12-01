import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/widgets/molecules/profile_header.dart';

class FriendRequestDialog extends StatelessWidget {
  const FriendRequestDialog(this.username, {Key? key}) : super(key: key);
  final String username;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: FutureBuilder(
        future: UserService.getInstance().getOtherUser(username),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            User? user = snapshot.data;
            if (user == null) return Container();
            return ProfileHeader(user);
          }
          if (snapshot.hasError) return Container();
          return const LinearProgressIndicator();
        },
      ),
      content: Text('Are you sure you want to add $username?'),
      actions: [
        IconButton(
          icon: const Icon(Icons.cancel_rounded, color: Colors.redAccent),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green),
          onPressed: () async {
            await UserService.getInstance().requestFriend(username);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
