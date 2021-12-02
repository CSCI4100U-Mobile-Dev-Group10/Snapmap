import 'package:latlong2/latlong.dart';

class Post {
  /// The [id] of the post from Firebase
  /// Should only be null when the post is initially created
  String? id;

  /// The [username] of the [User] that created the post
  final String username;

  /// The link in firebase storage to the image
  String imageUrl;

  /// The location that the photo was taken
  final LatLng latlong;

  /// A list of [username] for each [User] who has liked the photo
  final List<String> likes;

  Post(
    this.username,
    this.imageUrl,
    this.latlong, {
    this.id,
    this.likes = const <String>[],
  });

  factory Post.fromMap(String id, Map<String, dynamic> data) {
    print('post => $id');
    return Post(
      data['username'],
      data['imageUrl'],
      LatLng(data['lat'], data['long']),
      id: id,
      likes: List<String>.from(data['likes']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'imageUrl': imageUrl,
      'lat': latlong.latitude,
      'long': latlong.longitude,
      'likes': likes,
    };
  }
}
