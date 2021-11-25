/// [User] class
/// Should have two main ways to lookup a user:
/// By [email] which returns the username of the [User] (for authentication)
/// By [username] which is the primary way to retrieve a [User] (everything else)
class User {
  /// Primary id for the user (unique)
  String username;

  /// The email address used to signup (unique)
  String email;

  /// The password used in login
  String password;

  /// The display name used in application
  String displayName;

  /// The link of the profile picture
  String profileUrl;

  /// A list of [username] for every friend
  List<String> friends;

  /// A list of [username] for every other [User]
  /// that has requested to connect with this [User]
  List<String> receivedFriendRequests;

  /// A list of [username] for every other [User]
  /// that this [User] has requested to connect with
  List<String> sentFriendRequests;

  /// A list of [Post.id] for posts that this user has created
  List<String> posts;

  User(
    this.username,
    this.email,
    this.password,
    this.displayName,
    this.profileUrl, {
    this.friends = const <String>[],
    this.posts = const <String>[],
    this.receivedFriendRequests = const <String>[],
    this.sentFriendRequests = const <String>[],
  });

  factory User.fromMap(String username, Map<String, dynamic> data) {
    return User(
      username,
      data['email'],
      data['password'],
      data['displayName'] ?? '',
      data['profileUrl'] ?? '',
      friends: (data['friends'] ?? []).cast<String>(),
      posts: (data['posts'] ?? []).cast<String>(),
      receivedFriendRequests: (data['friends'] ?? []).cast<String>(),
      sentFriendRequests: (data['friends'] ?? []).cast<String>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'displayName': displayName,
      'profileUrl': profileUrl,
      'friends': friends,
      'posts': posts,
      'sentFriends': sentFriendRequests,
      'receivedFriends': receivedFriendRequests,
    };
  }
}
