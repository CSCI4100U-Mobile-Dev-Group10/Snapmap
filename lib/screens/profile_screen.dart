import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/widgets/molecules/friend_code.dart';
import 'package:snapmap/widgets/molecules/profile_header.dart';
import 'package:snapmap/widgets/organisms/friends_list.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = UserService.getInstance().getUser()!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProfileHeader(user),
        FriendCode(user),
        FriendsList(user)
      ],
    );
  }
}
