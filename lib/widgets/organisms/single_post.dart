import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/post.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/screens/map_screen.dart';
import 'package:snapmap/services/post_service.dart';
import 'package:snapmap/services/user_service.dart';

//Created this to just get an iage showing, need to make it dynamic per the user's screen
//not fully sure how though, need to research more
class SinglePost extends StatefulWidget {
  const SinglePost(this.post, {Key? key}) : super(key: key);
  final Post post;

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  bool isLiked = false;
  User user = UserService.getInstance().getCurrentUser()!;
  List<String> likes = [];
  @override
  void initState() {
    setState(() {
      likes = widget.post.likes;
      isLiked = widget.post.likes.contains(user.username);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const likesStyling = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    const usernameStyling = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    var username = '@' + widget.post.username;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox.expand(
          child: FittedBox(
            fit: BoxFit.cover,
            child: Image.network(
              widget.post.imageUrl,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                /// Username
                Text(
                  username,
                  style: usernameStyling,
                ),

                /// Side buttons
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      iconSize: 40,
                      onPressed: () {
                        Navigator.of(context).pushNamed(MapScreen.routeId,
                            arguments: widget.post.latlong);
                      },
                      icon: const Icon(
                        Icons.map,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      color: isLiked ? Colors.redAccent : Colors.white,
                      iconSize: 40,
                      onPressed: () async {
                        setState(() {
                          isLiked = !isLiked;

                          likes.removeWhere(
                              (element) => element == user.username);

                          if (isLiked) {
                            likes.add(user.username);
                          }
                        });

                        await PostService.getInstance()
                            .handleLikePost(widget.post.id!, isLiked);
                      },
                      icon: const Icon(Icons.favorite),
                    ),
                    Text(
                      likes.length.toString(),
                      style: likesStyling,
                    ),
                    const SizedBox(height: 50)
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
