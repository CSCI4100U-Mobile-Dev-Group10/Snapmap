import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong2/latlong.dart';
import 'package:snapmap/models/post.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/utils/km_to_latlong.dart';

class PostService {
  /// Singleton for this class
  PostService._();
  static final PostService _singleton = PostService._();
  factory PostService.getInstance() => _singleton;
  static final posts = FirebaseFirestore.instance.collection("Posts");

  Future<List<Post>> getPostsForUser(User user) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> results =
        (await posts.where('username', isEqualTo: user.username).get()).docs;
    return results
        .map((result) => Post.fromMap(result.id, result.data()))
        .toList();
  }

  Future<List<Post>> getPostsByLocation(
    LatLng latLng, {

    /// Distance in kilometers
    double distance = 10,
  }) async {
    double lat = latLng.latitude;
    double long = latLng.longitude;

    double latRange = kmToLatitude(distance);
    double longRange = kmToLongitude(distance, lat);

    /// Searches a square area with
    /// latitude: lat +/- latRange
    /// longitude: long +/- longRange
    List<QueryDocumentSnapshot<Map<String, dynamic>>> results = (await posts
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
            .get())
        .docs;

    return results
        .map((result) => Post.fromMap(result.id, result.data()))
        .toList();
  }
}
