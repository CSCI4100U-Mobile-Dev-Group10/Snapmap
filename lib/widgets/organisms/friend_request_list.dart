import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/widgets/molecules/profile_header.dart';

class FriendRequestList extends StatelessWidget {
  FriendRequestList({Key? key}) : super(key: key);
  final User user = UserService.getInstance().getCurrentUser()!;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: UserService.getInstance().currentUserStream(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          DocumentSnapshot<Map<String, dynamic>> doc =
              (snap.data! as DocumentSnapshot<Map<String, dynamic>>);
          User data = User.fromMap(doc.id, doc.data()!);
          return ListView.builder(
            itemCount: data.receivedFriendRequests.length,
            itemBuilder: (BuildContext context, int index) {
              return FutureBuilder(
                future: UserService.getInstance()
                    .getOtherUser(data.receivedFriendRequests[index]),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data == null) {
                      return Container();
                    }
                    return Row(
                      children: [
                        ProfileHeader(
                          snapshot.data as User,
                          showEdit: false,
                          avatarSize: 40,
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.redAccent,
                          ),
                          onPressed: () async {
                            await UserService.getInstance().handleFriendRequest(
                                user.receivedFriendRequests[index], false);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.check,
                            color: Color(0xFF0EA47A),
                          ),
                          onPressed: () async {
                            await UserService.getInstance().handleFriendRequest(
                                user.receivedFriendRequests[index], true);
                          },
                        ),
                      ],
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            },
          );
        });
  }
}
