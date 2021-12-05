import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/post_service.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/widgets/organisms/post_feed.dart';

class SocialFeedScreen extends StatefulWidget {
  const SocialFeedScreen({Key? key}) : super(key: key);

  @override
  State<SocialFeedScreen> createState() => _SocialFeedScreenState();
}

class _SocialFeedScreenState extends State<SocialFeedScreen> {
  final PostService posts = PostService.getInstance();
  final User user = UserService.getInstance().getCurrentUser()!;

  Map<String, Stream<QuerySnapshot<Map<String, dynamic>>>> feeds = {};
  late String currentFeed;

  @override
  void initState() {
    super.initState();
    feeds['Friends'] = posts.getFriendPostsForUser(user);
    setState(() {
      // default to the first feed in the list
      currentFeed = feeds.keys.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Stream<QuerySnapshot<Map<String, dynamic>>> locations =
    //     posts.getFriendPostsForUser(user);

    return SizedBox.expand(
      child:
          PostFeed(feeds[currentFeed]!, feeds.keys.toList(), setFeed: (feed) {
        setState(() {
          currentFeed = feed;
        });
      }),
    );
  }
}
