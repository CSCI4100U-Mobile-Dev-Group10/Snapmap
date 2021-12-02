import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/post.dart';
import 'package:snapmap/widgets/atoms/loading.dart';
import 'package:snapmap/widgets/organisms/single_post.dart';

class PostFeed extends StatelessWidget {
  const PostFeed(this.posts, {Key? key}) : super(key: key);
  final Stream<QuerySnapshot<Map<String, dynamic>>> posts;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: posts,
      builder: (BuildContext ctx,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) return const Loading();
        List<Post> data = snapshot.data!.docs
            .map((item) => Post.fromMap(item.id, item.data()))
            .toList();
        if (data.isEmpty) {
          return const Center(child: Text('No friends have posted 😭'));
        }
        Size size = MediaQuery.of(context).size;
        return SizedBox(
          height: size.height,
          width: size.width,
          child: PageView.builder(
            padEnds: false,
            scrollDirection: Axis.vertical,
            physics: const PageScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (ctx, index) {
              return SinglePost(data[index]);
            },
          ),
        );
      },
    );
  }
}
