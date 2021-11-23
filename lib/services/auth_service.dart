import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapmap/globals.dart';

// this file holds functions for sign up and authorization when loggin in
// the functions interact with the firestore

final users = FirebaseFirestore.instance.collection("Users");


  Future<bool> authUser(Map data) async {
    bool returnValue = true;
    var dict;

    await users.doc(data['username']).get().then((DocumentSnapshot snapshot) {
      try {
        dict = snapshot.data() as Map;
      } on StateError catch (e) {
        print('No nested field exists!');
      }

      if (snapshot.data() != null) {
        user.username = data['username'];
        user.email = dict['email'];
        user.password = data['password'];
        user.profileURL = dict['profileURL'];
        user.displayName = dict['display_name'];
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

  Future<String> signUp(Map data) async {
    String returnValue = 'true';
    await users.doc(data['username']).get().then((value) async {
      await users
          .where('email', isEqualTo: data['email'])
          .get()
          .then((emailInstance) {
        if (emailInstance.docs.isNotEmpty) {
          returnValue = 'email';
        } else {
          if (value.data() != null) {
            returnValue = 'username';
          } else if (data['conPass'] == data['password']) {
            users.doc(data['username']).set({
              'email': data['email'],
              'password': data['password']
            }).then((value) {
              print("Added User");
            }).catchError((error) => print("Failed to add User: $error"));
          } else {
            returnValue = 'password';
          }
        }
      });
    });
    return returnValue;
  }
