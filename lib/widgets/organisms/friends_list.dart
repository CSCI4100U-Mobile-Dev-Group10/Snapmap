import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/widgets/molecules/single_friend.dart';

class FriendsList extends StatefulWidget {
  const FriendsList(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  State<FriendsList> createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  List<FriendListItem> friendList = <FriendListItem>[];
  @override
  void initState() {
    super.initState();
    List<FriendListItem> friendList = <FriendListItem>[
      FriendListItem(widget.user),
      FriendListItem(widget.user)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(8),
      itemCount: friendList.length,
      itemBuilder: (BuildContext context, int index) {
        return friendList[index];
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
