import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:snapmap/utils/logger.dart';

FirebaseStorage _storage = FirebaseStorage.instanceFor(
  app: FirebaseFirestore.instance.app,
  bucket: 'gs://snapmap-46530.appspot.com',
);

/// General Upload Method
Future<String> _uploadImage(String filename, Uint8List data) async {
  try {
    await _storage.ref(filename).putData(data);
    return await _storage.ref(filename).getDownloadURL();
  } on FirebaseException catch (e) {
    logger.e(e);
  }
  return '';
}

String _getUserProfileImageLink(String username) => 'profile_$username';

/// Upload a profile image for a user
Future<String> uploadProfileImage(String username, Uint8List data) async {
  String filename = _getUserProfileImageLink(username);
  return await _uploadImage(filename, data);
}

String _getPostImageLink(String username, String id) => '$username/$id';

/// Upload the image for a post
Future<String> uploadPostImage(
    String username, String id, Uint8List data) async {
  String filename = _getPostImageLink(username, id);
  return await _uploadImage(filename, data);
}
