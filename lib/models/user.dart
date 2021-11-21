import 'package:snapmap/models/post.dart';

/// [User] class
/// Should have two main ways to lookup a user:
/// By [email] which returns the username of the [User] (for authentication)
/// By [username] which is the primary way to retrieve a [User] (everything else)
class User {
  /// Primary id for the user (unique)
  final String username;

  /// The email address used to signup (unique)
  final String email;

  /// A list of [username] for every friend
  final List<String> friends;

  /// A list of [username] for every other [User]
  /// that has requested to connect with this [User]
  final List<String> receivedFriendRequests;

  /// A list of [username] for every other [User]
  /// that this [User] has requested to connect with
  final List<String> sentFriendRequests;

  /// A list of [Post.id] for posts that this user has created
  final List<String> posts;

  const User(
    this.username,
    this.email, {
    this.friends = const <String>[],
    this.posts = const <String>[],
    this.receivedFriendRequests = const <String>[],
    this.sentFriendRequests = const <String>[],
  });
}
