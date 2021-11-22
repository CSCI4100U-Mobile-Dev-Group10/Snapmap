// ignore_for_file: prefer_const_constructors, avoid_print, avoid_single_cascade_in_expression_statements, invalid_return_type_for_catch_error

import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:snapmap/services/users.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapmap/widgets/organisms/auth/login_form.dart';
import 'package:snapmap/services/auth_service.dart';

class loginForm extends StatefulWidget {
  loginForm({Key? key}) : super(key: key);

  @override
  _loginFormState createState() => _loginFormState();
}

class _loginFormState extends State<loginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String username = '';
  String confirmPass = '';
  String errorText = '';
  bool pageFlag = false;
  bool errorExists = false;

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

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
      await users.where('email', isEqualTo: data['email']).get().then((emailInstance) {
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
              print("Added User");
            }).catchError((error) => print("Failed to add User: $error"));
          }
        }
      });
    });
    return returnValue;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: "Username"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field needs input';
                }
                return null;
              },
              onSaved: (value) {
                username = value.toString();
              },
            ),
            Visibility(
              visible: pageFlag,
              child: TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field needs input';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value.toString();
                },
              ),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: "Password"),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field needs input';
                }
                return null;
              },
              onSaved: (value) {
                password = value.toString();
              },
            ),
            Visibility(
              visible: pageFlag,
              child: TextFormField(
                decoration: InputDecoration(labelText: "Confirm Password"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field needs input';
                  }
                  return null;
                },
                onSaved: (value) {
                  confirmPass = value.toString();
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Visibility(visible: errorExists, child: Text(errorText)),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (!pageFlag) {
                      var returnValue = await _authUser({
                        'username': username,
                        'password': password,
                      });
                      if (returnValue == false) {
                        // if the login fails (user does not exist) or entered wrong password
                        errorText =
                            'login attempt failed email or password is wrong';
                        errorExists = true;
                        setState(() {});
                      } else {
                        errorExists = false;
                        setState(() {});
                        Navigator.pushNamed(context, '/socialFeed');
                      }
                    } else {
                      var returnValue = await _signUp({
                        'username': username,
                        'email': email,
                        'password': password,
                      });
                      if (returnValue == false) {
                        errorExists = true;
                        errorText = 'Username or Email already in use';
                        setState(() {});
                      } else {
                        errorExists = false;
                        if (password == confirmPass) {
                          pageFlag = false;
                          setState(() {});
                        } else {
                          errorText =
                              'Confirmation of password does not match entered password!';
                          errorExists = true;
                          setState(() {});
                        }
                      }
                    }
                  }
                },
                child: pageFlag ? Text("Sign Up") : Text("Login")),
            TextButton(
                onPressed: () {
                  errorExists = false;
                  setState(() {
                    pageFlag = !pageFlag;
                  });
                },
                child: pageFlag ? Text("Login") : Text("Sign Up"))
          ],
        ));
  }
}
