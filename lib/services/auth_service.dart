import 'package:cloud_firestore/cloud_firestore.dart';

final users = FirebaseFirestore.instance.collection("Users");

Future<bool> _authUser(Map data) async {
  bool returnValue = true;
  var dict;

  await users.doc(data['username']).get().then((DocumentSnapshot snapshot) {
    try {
      dict = snapshot.data() as Map;
    } on StateError catch (e) {
      print('No nested field exists!');
    }

    if (snapshot.data() != null) {
      if (data['password'] != dict['password']) {
        returnValue = false;
      }
    } else {
      returnValue = false;
    }
  }).catchError((error) {
    returnValue = false;
  });
  return returnValue;
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
          users.doc(data['username']).set({
            'email': data['email'],
            'password': data['password']
          }).then((value) {
            print("Added User");
          }).catchError((error) => print("Failed to add User: $error"));
        }
      }
    });
  });
  return returnValue;
}