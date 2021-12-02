import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/post_service.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/widgets/organisms/post_feed.dart';

class SocialFeedScreen extends StatelessWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostService posts = PostService.getInstance();
    User user = UserService.getInstance().getCurrentUser()!;
    Stream<QuerySnapshot<Map<String, dynamic>>> friends =
        posts.getFriendPostsForUser(user);
    // Stream<QuerySnapshot<Map<String, dynamic>>> locations =
    //     posts.getFriendPostsForUser(user);

    return SizedBox.expand(
      child: PostFeed(friends),
    );
  }
}
