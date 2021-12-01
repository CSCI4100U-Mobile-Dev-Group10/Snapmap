import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/widgets/molecules/profile_header.dart';

class FriendRequestDialog extends StatefulWidget {
  const FriendRequestDialog(this.username, {Key? key}) : super(key: key);
  final String username;

  @override
  State<FriendRequestDialog> createState() => _FriendRequestDialogState();
}

class _FriendRequestDialogState extends State<FriendRequestDialog> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    if (isAccepted) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return AlertDialog(
      title: FutureBuilder(
        future: UserService.getInstance().getOtherUser(widget.username),
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
      content: Text('Are you sure you want to add ${widget.username}?'),
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
            if (!isAccepted) {
              setState(() {
                isAccepted = true;
              });
              await UserService.getInstance().requestFriend(widget.username);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
