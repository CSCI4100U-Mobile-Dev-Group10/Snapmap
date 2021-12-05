import 'package:flutter/material.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/utils/logger.dart';

class FriendRequestSender extends StatefulWidget {
  const FriendRequestSender({ Key? key }) : super(key: key);

  @override
  _FriendRequestSenderState createState() => _FriendRequestSenderState();
}

class _FriendRequestSenderState extends State<FriendRequestSender> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _controller = new TextEditingController();
  String usernameToSend = '';
  bool  flag = false;

  checkifUserExists(String us) async {
    var result =
        await UserService.getInstance().getOtherUser(us);
    // verify user exists
    if (result == null) return false;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: Form(
        key: _formKey,
        child: Stack(
          children: [
            Container(
              height: 100,
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width) * 0.01,
              top: 5,
              width: (MediaQuery.of(context).size.width) * 0.78,
              child: TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Send a friend request',
                  border: OutlineInputBorder(),
                  hintText: 'Enter username (e.g Andrew)',
                ),
                onChanged: (text) async {
                  await checkifUserExists(text).then((value) {
                    flag = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Must enter username';
                  } else if (!flag) {
                    return 'User does not exist';
                  } else if (UserService.getInstance().getCurrentUser()!.friends.contains(value.toString())) {
                    return 'You are already friends with ${value.toString()}';
                  } else if (UserService.getInstance().getCurrentUser()!.sentFriendRequests.contains(value.toString())) {
                    return 'You have already sent a request to ${value.toString()}';
                  } else if (UserService.getInstance().getCurrentUser()!.receivedFriendRequests.contains(value.toString())) {
                    return 'You have already recieved a request from ${value.toString()}';
                  } else if (UserService.getInstance().getCurrentUser()!.username == value.toString()) {
                    return 'You cannot request yourself silly';
                  }
                  return null;
                },
                onSaved: (value) {
                  usernameToSend = value.toString();
                },
              ),
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width) * 0.81,
              top: 5,
              width: (MediaQuery.of(context).size.width) * 0.15,
              height: 57,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _controller.clear();
                    var value = await UserService.getInstance().getOtherUser(usernameToSend);
                    if (value != null) {
                      await UserService.getInstance().requestFriend(usernameToSend);
                    } else {
                      logger.i('user does not exist');
                    }
                  }
                },
                child: const Icon(Icons.send),
              ),
            ),
          ],
        ),
      ),
    );
  }
}