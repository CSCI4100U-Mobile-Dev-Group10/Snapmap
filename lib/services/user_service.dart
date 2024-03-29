import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/notification_services.dart';
import 'package:snapmap/utils/logger.dart';

class UserService {
  /// Singleton for this class
  UserService._();
  static final UserService _singleton = UserService._();
  factory UserService.getInstance() => _singleton;
  static final users = FirebaseFirestore.instance.collection("Users");
  final newFriends = FriendRequests();

  // *
  // * CURRENT USER OPERATIONS - (currently authenticated user)
  // *

  /// Currently authenticated user
  User? _user;

  /// Set or get the currently authenticated user
  /// Then activate the refreshUser event to keep the [_user] in sync
  void setUser(User? user) {
    bool isDifferentUser = _user?.username != user?.username && user != null;
    if (isDifferentUser) {
      _userStream?.cancel();
    }
    _user = user;
    if (isDifferentUser) {
      _activateRefreshEvent(user.username);
    }
  }

  User? getCurrentUser() => _user;

  // *
  // * REFRESH USER OPERATIONS - keep the user in sync
  // *

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? _userStream;

  void _activateRefreshEvent(String username) {
    Stream<DocumentSnapshot<Map<String, dynamic>>> stream =
        doc(username).snapshots();
    _userStream = stream.listen((event) {
      _refresh(event);
      newFriends.showNotification();
    });
  }

  /// refresh the data of the currently authenticated user
  /// the result is whether the operation was successful
  Future<bool> _refresh(DocumentSnapshot<Map<String, dynamic>> event) async {
    // verify that the user is authenticated
    if (_user?.username == null) return false;

    // get the user's data
    Map<String, dynamic>? data = event.data();

    // verify the user's data
    if (data == null) return false;

    // set the updated data
    _user = User.fromMap(data['username'], data);
    return true;
  }

  // *
  // * FRIEND OPERATIONS
  // *

  Future<User?> getOtherUser(String otherUsername) async {
    try {
      // get the user's ref
      DocumentReference<Map<String, dynamic>> otherUser = doc(otherUsername);

      // get the user's data
      Map<String, dynamic>? otherData = await data(otherUser);

      // verify that user exists
      if (otherData == null) return null;

      return User.fromMap(otherUsername, otherData);
    } catch (_) {
      return null;
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> currentUserStream() {
    DocumentReference<Map<String, dynamic>> currentUser = doc(_user!.username);
    return currentUser.snapshots();
  }

  /// request a friend as the authenticated user
  /// the result is whether the operation was successful
  Future<bool> requestFriend(String otherUsername) async {
    try {
      bool res = true;
      // verify that the user is authenticated
      if (_user?.username == null) return false;

      // get both user references
      DocumentReference<Map<String, dynamic>> currentUser =
          doc(_user!.username);
      DocumentReference<Map<String, dynamic>> otherUser = doc(otherUsername);

      // get current data of each user
      Map<String, dynamic>? currentData = await data(currentUser);
      Map<String, dynamic>? otherData = await data(otherUser);

      // verify that both users exist
      if (currentData == null || otherData == null) return false;

      // check that they aren't already friends
      // and ensure that the friends relationship is persistent
      bool curr = currentData['friends'].contains(otherUsername);
      bool other = otherData['friends'].contains(_user!.username);

      if (curr || other) {
        if (!curr) {
          currentData['friends'].add(otherUsername);
        }
        if (!other) {
          otherData['friends'].add(_user!.username);
        }
        res = false;
      }

      if (res) {
        // add the users to the respective side of the friend request
        currentData['sentFriends'].add(otherUsername);
        otherData['receivedFriends'].add(_user!.username);
      }

      // set both users in parallel
      await Future.wait([
        currentUser.set(currentData),
        otherUser.set(otherData),
      ]);

      return res;
    } catch (_) {
      logger.w(_);
      return false;
    }
  }

  Future<bool> handleFriendRequest(String otherUsername, bool accepted) async {
    try {
      // verify that the user is authenticated
      if (_user?.username == null) return false;

      // get both user references
      DocumentReference<Map<String, dynamic>> currentUser =
          doc(_user!.username);
      DocumentReference<Map<String, dynamic>> otherUser = doc(otherUsername);

      // get current data of each user
      Map<String, dynamic>? currentData = await data(currentUser);
      Map<String, dynamic>? otherData = await data(otherUser);

      // verify that both users exist
      if (currentData == null || otherData == null) return false;
      List currentList = currentData['receivedFriends'];
      List otherList = otherData['sentFriends'];
      // add the users to the respective side of the friend request
      currentList.removeWhere((element) => element == otherUsername);
      otherList.removeWhere((element) => element == _user!.username);

      if (accepted) {
        if (!currentData['friends'].contains(otherUsername)) {
          currentData['friends'].add(otherUsername);
        }
        if (!otherData['friends'].contains(_user!.username)) {
          otherData['friends'].add(_user!.username);
        }
      }

      currentData['receivedFriends'] = currentList;
      otherData['sentFriends'] = otherList;

      // set both users in parallel
      await Future.wait([
        currentUser.set(currentData),
        otherUser.set(otherData),
      ]);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> removeFriend(String otherUsername) async {
    try {
      // verify that the user is authenticated
      if (_user?.username == null) return false;

      // get both user references
      DocumentReference<Map<String, dynamic>> currentUser =
          doc(_user!.username);
      DocumentReference<Map<String, dynamic>> otherUser = doc(otherUsername);

      // get current data of each user
      Map<String, dynamic>? currentData = await data(currentUser);
      Map<String, dynamic>? otherData = await data(otherUser);

      // verify that both users exist
      if (currentData == null || otherData == null) return false;

      // remove the friends from both users
      (currentData['friends'])
          .removeWhere((element) => element == otherUsername);
      (otherData['friends'])
          .removeWhere((element) => element == _user!.username);

      // set both users in parallel
      await Future.wait([
        currentUser.set(currentData),
        otherUser.set(otherData),
      ]);

      return true;
    } catch (_) {
      return false;
    }
  }

  // *
  // * GENERAL OPERATIONS
  // *

  DocumentReference<Map<String, dynamic>> doc(String username) {
    return users.doc(username);
  }

  Future<Map<String, dynamic>?> data(
      DocumentReference<Map<String, dynamic>> doc) {
    return doc.get().then((res) => res.data());
  }
}
