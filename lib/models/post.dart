class Post {
  /// The [id] of the post from Firebase
  /// Should only be null when the post is initially created
  String? id;

  /// The [username] of the [User] that created the post
  final String username;

  // TODO
  // * Image - Once image storage service has been determined
  // * Geolocation - Once geolocation and map libraries have been determined

  /// A list of [username] for each [User] who has liked the photo
  final List<String> likes;

  Post(
    this.username, {
    this.id,
    this.likes = const <String>[],
  });
}
