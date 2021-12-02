import 'package:flutter/material.dart';
import 'package:snapmap/models/post.dart';
import 'package:snapmap/widgets/organisms/single_post.dart';

class PostFeed extends StatelessWidget {
  const PostFeed(this.posts, {Key? key}) : super(key: key);
  final Stream<List<Post>> posts;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: posts,
      builder: (BuildContext ctx, AsyncSnapshot snapshot) {
        // if (!snapshot.hasData) {
        //   return const Center(child: CircularProgressIndicator());
        // }
        List<Post> data = snapshot.data ?? [];
        if (data.isEmpty) {
          return Text('ur a loser');
        }
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (ctx, index) {
            return SinglePost(data[index]);
          },
        );
      },
    );
  }
}
