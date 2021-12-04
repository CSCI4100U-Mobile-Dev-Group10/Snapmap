import 'dart:typed_data';
import 'package:stream_transform/stream_transform.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:snapmap/models/post.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/geo_service.dart';
import 'package:snapmap/services/photo_service.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/utils/km_to_latlong.dart';

class PostService {
  /// Singleton for this class
  PostService._();
  static final PostService _singleton = PostService._();
  factory PostService.getInstance() => _singleton;
  static final _posts = FirebaseFirestore.instance.collection("Posts");

  Stream<QuerySnapshot<Map<String, dynamic>>> getFriendPostsForUser(User user) {
    List<String> filterArray = (user.friends.isNotEmpty) ? user.friends : [''];
    Stream<QuerySnapshot<Map<String, dynamic>>> results = _posts
        .where('username', whereIn: filterArray)
        .where('imageUrl', isNotEqualTo: '')
        .snapshots();
    return results;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPostsForCurrentUser() {
    User? user = UserService.getInstance().getCurrentUser();

    /// This will be thrown when:
    /// the user attempts to query the database before they've authenticated
    if (user == null) NullThrownError();

    Stream<QuerySnapshot<Map<String, dynamic>>> results = _posts
        .where('username', isEqualTo: user!.username)
        .where('imageUrl', isNotEqualTo: '')
        .snapshots();

    return results;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getPostsByLocation(
    LatLng latLng, {

    /// Distance in kilometers
    double distance = 10,
  }) {
    double lat = latLng.latitude;
    double long = latLng.longitude;

    double latRange = kmToLatitude(distance);
    double longRange = kmToLongitude(distance, lat);

    /// Searches a square area with
    /// latitude: lat +/- latRange
    /// longitude: long +/- longRange
    Stream<QuerySnapshot<Map<String, dynamic>>> results = _posts
        .where(
          'latitude',
          isLessThanOrEqualTo: lat + latRange,
          isGreaterThanOrEqualTo: lat - latRange,
        )
        .where(
          'longitude',
          isLessThanOrEqualTo: long + longRange,
          isGreaterThanOrEqualTo: long - longRange,
        )
        .where(
          'username',
          isNotEqualTo: UserService.getInstance().getCurrentUser()!.username,
        )
        .where('imageUrl', isNotEqualTo: '')
        .snapshots();
    return results;
  }

  /// The uploadPost function can throw a [PermissionException]
  /// if the location permissions are blocked
  Future<bool> uploadPost(Uint8List image) async {
    // Get the current user
    User? user = UserService.getInstance().getCurrentUser();
    if (user == null) return false;

    // Get latlong for the post
    LatLng latlong = await getCurrentLocation();

    // Create the initial post
    Post post = Post(user.username, '', latlong);

    try {
      // Store the post to generate the id for the imageUrl
      DocumentReference<Map<String, dynamic>> ref =
          await _posts.add(post.toMap());

      // Upload the image and retrieve imageUrl
      String imageUrl = await uploadPostImage(user.username, ref.id, image);

      // Update the post with id and imageUrl
      post.id = ref.id;
      post.imageUrl = imageUrl;

      // Store the updated post
      await ref.set(post.toMap());

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> handleLikePost(String id, bool liked) async {
    try {
      // Get the current user
      User? user = UserService.getInstance().getCurrentUser();
      if (user == null) return false;

      /// Get the ref to the post
      DocumentReference<Map<String, dynamic>> ref = _posts.doc(id);

      /// Get the data from the post ref
      Map<String, dynamic>? data = (await ref.get()).data();
      if (data == null) return false;

      /// Remove all instances of [user.username] to prevent double counting.
      (data['likes'] as List<String>)
          .removeWhere((element) => element == user.username);

      /// If liked add 1 instance of [user.username]
      if (liked) {
        (data['likes'] as List<String>).add(user.username);
      }

      /// Update the post data
      ref.set(data);

      return true;
    } catch (_) {
      return false;
    }
  }
}
