import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/models/post.dart';
import 'package:snapmap/screens/map_screen.dart';

//Created this to just get an iage showing, need to make it dynamic per the user's screen
//not fully sure how though, need to research more
class SinglePost extends StatelessWidget {
  const SinglePost(this.post, {Key? key}) : super(key: key);
  final Post post;

  @override
  Widget build(BuildContext context) {
    var currColor = Colors.white;
    var likesStyling =
        const TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    var usernameStyling =
        const TextStyle(fontSize: 50, fontWeight: FontWeight.bold);
    var username = '@' + post.username;
    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: Stack(
          children: [
            Image.network(
              post.imageUrl,
              fit: BoxFit.fill,
            ),
            // TODO overlay still hardcoced sizing

            Positioned(
                top: 800,
                left: 600,
                child: IconButton(
                    iconSize: 100,
                    onPressed: () {
                      Navigator.of(context).pushNamed(MapScreen.routeId,
                          arguments: post.latlong);
                    },
                    icon: const Icon(
                      Icons.map,
                      color: Colors.white,
                    ))),
            Positioned(
                top: 900,
                left: 600,
                child: Column(children: [
                  IconButton(
                      color: currColor,
                      iconSize: 100,
                      onPressed: () {
                        currColor = Colors.redAccent;
                      },
                      icon: const Icon(Icons.favorite)),
                  Text(post.likes.length.toString(), style: likesStyling),
                ])),
            Positioned(
              top: 1100,
              left: 50,
              child: Text(
                username,
                style: usernameStyling,
              ),

              // Like button and map button here
              // Like button will use PostService
              // Map button you need to create a LatLng and point it at the map screen
            )
          ],
        ),
      ),
    );
  }
}
