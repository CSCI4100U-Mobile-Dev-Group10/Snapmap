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
    //
    return DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const TabBar(
              tabs: [
                PostTabs(icon: Icons.people),
                PostTabs(
                    icon: Icons
                        .location_city), //will change not sure what icon best represents location
              ],
              indicatorColor: Color(0xFF12D39D),
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height - 118,
                child: TabBarView(children: [
                  StreamBuilder(
                    stream: posts,
                    builder: (BuildContext ctx,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (!snapshot.hasData) return const Loading();
                      List<Post> data = snapshot.data!.docs
                          .map((item) => Post.fromMap(item.id, item.data()))
                          .toList();
                      if (data.isEmpty) {
                        return const Center(
                            child: Text('No friends have posted 😭'));
                      }
                      Size size = MediaQuery.of(context).size;
                      return SizedBox(
                        height: size.height,
                        width: size.width,
                        child: Stack(
                          children: [
                            PageView.builder(
                              padEnds: false,
                              scrollDirection: Axis.vertical,
                              physics: const PageScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (ctx, index) {
                                return SinglePost(data[index]);
                              },
                            ),
                            // TODO Tab controls here

                            /// [feeds] contains the names of the feeds for the buttons
                            ///
                            /// Only show the buttons if:
                            /// [setFeed] is not null
                            /// and feeds.length > 1
                            ///
                            /// That way we can reuse this widget for the profile screen
                            ///
                            /// example:
                            /// feeds = ['Friends', 'Locations'];
                            /// when they press Friends... call setFeed('Friends')
                            /// when they press Locations... call setFeed('Locations')
                          ],
                        ),
                      );
                    },
                  ),
                  const Center(child: Text('By Area'))
                ])),
          ],
        ));
  }
}
