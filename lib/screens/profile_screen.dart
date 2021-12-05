import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/widgets/molecules/friend_code.dart';
import 'package:snapmap/widgets/molecules/profile_header.dart';
import 'package:snapmap/widgets/organisms/friend_request_list.dart';
import 'package:snapmap/widgets/organisms/friends_list.dart';
import '../widgets/molecules/profile_tab_labels.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = UserService.getInstance().getCurrentUser()!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Column(
          children: [
            ProfileHeader(user),
            // create TabView to alternate between your QR code and your friend list
            DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        ProfileTabs(icon: Icons.people),
                        ProfileTabs(icon: Icons.qr_code),
                        ProfileTabs(icon: Icons.person_add_alt_1)
                      ],
                      indicatorColor: Color(0xFF12D39D),
                    ),
                    SizedBox(
                      height: 400,
                      child: TabBarView(children: [
                        FriendsList(user),
                        FriendCode(user),
                        FriendRequestList(),
                      ]),
                    ),
                  ],
                ))
          ],
        ),
        ]
      ),
    );
  }
}
