import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';

class Post {
  /// The [id] of the post from Firebase
  /// Should only be null when the post is initially created
  String? id;

  /// The [username] of the [User] that created the post
  final String username;

  /// The link in firebase storage to the image
  final String imageUrl;

  /// The location that the photo was taken
  final LatLng latlong;

  /// The time that the post was taken
  final Timestamp timestamp;

  /// A list of [username] for each [User] who has liked the photo
  final List<String> likes;

  Post(
    this.username,
    this.imageUrl,
    this.latlong, {
    this.id,
    Timestamp? timestamp,
    this.likes = const <String>[],
  }) : timestamp = timestamp ?? Timestamp.now();

  factory Post.fromMap(String id, Map<String, dynamic> data) {
    return Post(
      data['username'],
      data['imageUrl'],
      data['latlong'],
      id: id,
      likes: data['likes'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'imageUrl': imageUrl,
      'latlong': latlong,
      'likes': likes,
      'timestamp': timestamp,
    };
  }
}
