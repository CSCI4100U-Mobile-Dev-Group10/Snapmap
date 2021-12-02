import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/post.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/post_service.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/widgets/organisms/post_feed.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  _SocialFeedScreenState createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  PostService posts = PostService.getInstance();
  User user = UserService.getInstance().getCurrentUser()!;

  @override
  Widget build(BuildContext context) {
    bool hasFriends = user.friends.isNotEmpty;
    Stream<List<Post>> friends = posts.getFriendPostsForUser(user);

    return PostFeed(friends);
  }
}
