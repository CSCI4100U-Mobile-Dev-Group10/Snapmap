class Post {
  /// The [id] of the post from Firebase
  /// Should only be null when the post is initially created
  String? id;

  /// The [username] of the [User] that created the post
  final String username;

  /// The link in firebase storage to the image
  final String imageUrl;

  /// The latitude and longitude are separated here for filtering purposes
  final double latitude;
  final double longitude;

  /// A list of [username] for each [User] who has liked the photo
  final List<String> likes;

  Post(
    this.username,
    this.imageUrl,
    this.latitude,
    this.longitude, {
    this.id,
    this.likes = const <String>[],
  });
}
