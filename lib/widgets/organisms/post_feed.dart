import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/post.dart';
import 'package:snapmap/widgets/atoms/loading.dart';
import 'package:snapmap/widgets/molecules/post_tabs_labels.dart';
import 'package:snapmap/widgets/organisms/single_post.dart';

class PostFeed extends StatelessWidget {
  const PostFeed(
    this.posts,
    this.feeds, {
    this.setFeed,
    Key? key,
  }) : super(key: key);

  final Stream<QuerySnapshot<Map<String, dynamic>>> posts;

  final void Function(String)? setFeed;
  final List<String> feeds;

  @override
  Widget build(BuildContext context) {
    //As of right now, feeds only has 1 value of friends,  when running program,
    //the error for cannot get current appears.

    return SizedBox(
      height: MediaQuery.of(context).size.height - 118,
      child: StreamBuilder(
        stream: posts,
        builder: (BuildContext ctx,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) return const Loading();
          List<Post> data = snapshot.data!.docs
              .map((item) => Post.fromMap(item.id, item.data()))
              .toList();
          Size size = MediaQuery.of(context).size;
          return SizedBox(
            height: size.height,
            width: size.width,
            child: Stack(
              children: [
                if (data.isEmpty) const Center(child: Text('No posts 😭')),
                if (data.isNotEmpty)
                  PageView.builder(
                    padEnds: false,
                    scrollDirection: Axis.vertical,
                    physics: const PageScrollPhysics(),
                    itemCount: data.length,
                    itemBuilder: (ctx, index) {
                      return SinglePost(data[index]);
                    },
                  ),
                if (feeds.length > 1 && setFeed != null)
                  SafeArea(
                    child: DefaultTabController(
                      length: feeds.length,
                      child: TabBar(
                        onTap: (i) => setFeed!(feeds[i]),
                        tabs: const [
                          PostTabs(icon: Icons.people),
                          PostTabs(
                              icon: Icons
                                  .location_city), //will change not sure what icon best represents location
                        ],
                        indicatorColor: const Color(0xFF12D39D),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
