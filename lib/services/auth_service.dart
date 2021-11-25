import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/services/user_service.dart';
import 'package:snapmap/utils/logger.dart';

final users = FirebaseFirestore.instance.collection("Users");

Future<bool> authUser(Map data) async {
  Map<String, dynamic>? dict;

  try {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await users.doc(data['username']).get();
    dict = doc.data();
  } on StateError {
    logger.e('No nested field exists!');
    return false;
  } catch (e) {
    logger.e(e);
    return false;
  }

  if (dict == null) return false;
  if (data['password'] != dict['password']) return false;
  UserService.getInstance().setUser(User.fromMap(data['username'], dict));
  return true;
}

Future<String> signUp(Map<String, dynamic> data) async {
  try {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await users.doc(data['username']).get();

    QuerySnapshot<Map<String, dynamic>> emailDoc =
        await users.where('email', isEqualTo: data['email']).get();

    if (emailDoc.docs.isNotEmpty) return 'email';
    if (userDoc.data() != null) return 'username';
    if (data['password'] != data['conPass']) return 'password';

    await users
        .doc(data['username'])
        .set({'email': data['email'], 'password': data['password']});

    logger.i('Added User => ${data['username']}');
  } catch (e) {
    logger.e(e);
    return 'error';
  }
  print(data);
  UserService.getInstance().setUser(User.fromMap(data['username'], data));
  return '';
}
