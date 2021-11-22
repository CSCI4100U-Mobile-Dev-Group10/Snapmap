import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapmap/utils/logger.dart';

final users = FirebaseFirestore.instance.collection("Users");

Future<bool> authUser(Map data) async {
  Map<String, dynamic>? dict;

  try {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await users.doc(data['username']).get();
    dict = snapshot.data();
  } on StateError {
    logger.e('No nested field exists!');
  } catch (e) {
    logger.e(e);
  }
  if (dict == null) return false;
  if (data['password'] != dict['password']) return false;
  return true;
}

Future<bool> _signUp(Map data) async {
  bool returnValue = true;
  await users.doc(data['username']).get().then((value) async {
    await users
        .where('email', isEqualTo: data['email'])
        .get()
        .then((emailInstance) {
      if (emailInstance.docs.isNotEmpty) {
        returnValue = false;
      } else {
        if (value.data() != null) {
          returnValue = false;
        } else {
          users
              .doc(data['username'])
              .set({'email': data['email'], 'password': data['password']}).then(
                  (value) {
            logger.i("Added User");
          }).catchError((error) {
            logger.e(error);
          });
        }
      }
    });
  });
  return returnValue;
}
