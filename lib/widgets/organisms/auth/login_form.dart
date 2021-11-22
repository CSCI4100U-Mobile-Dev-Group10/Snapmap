// ignore_for_file: prefer_const_constructors, avoid_print, avoid_single_cascade_in_expression_statements, invalid_return_type_for_catch_error

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class loginForm extends StatefulWidget {
  loginForm({Key? key}) : super(key: key);

  @override
  _loginFormState createState() => _loginFormState();
}

class _loginFormState extends State<loginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _accountRecovery = TextEditingController();

  String email = '';
  String password = '';
  String username = '';
  String confirmPass = '';
  String errorText = '';
  bool pageFlag = false;
  bool errorExists = false;
  bool redeyeOn = false;

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

  Future<String> _signUp(Map data) async {
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

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle),
                labelText: "Username",
                border: OutlineInputBorder(),
              ),
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
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: pageFlag,
              child: TextFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email),
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
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
            SizedBox(
              height: 10,
            ),
            TextFormField(
              obscureText: !redeyeOn,
              enableSuggestions: false,
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    redeyeOn = !redeyeOn;
                    setState(() {});
                  },
                  icon: redeyeOn
                      ? Icon(Icons.remove_red_eye_outlined)
                      : Icon(Icons.remove_red_eye),
                ),
              ),
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
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: pageFlag,
              child: TextFormField(
                obscureText: !redeyeOn,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
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
            Visibility(
                visible: errorExists,
                child: Text(
                  errorText,
                  style: TextStyle(color: Colors.red),
                )),
            SizedBox(
              height: 10,
            ),
            Visibility(
              visible: !pageFlag,
              child: InkWell(
                child: Text("Forgot Password?"),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Account Recovery"),
                          content: Text("Enter email to recover password:"),
                          actions: [
                            TextField(
                              decoration: InputDecoration(
                                label: Text('Email'),
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              controller: _accountRecovery,
                            ),
                            TextButton(
                                onPressed: () {
                                  return Navigator.pop(
                                      context, _accountRecovery.text);
                                },
                                child: Text("Send Email")),
                          ],
                        );
                      }).then((value) async {
                    var emailAlert = value;

                    await users
                        .where('email', isEqualTo: emailAlert)
                        .get()
                        .then((emailInstance) async {
                      if (emailInstance.docs.isNotEmpty) {
                        var data = emailInstance.docs.first.data() as Map;
                        var id = emailInstance.docs.single.id;

                        final url = Uri.parse(
                            'https://api.emailjs.com/api/v1.0/email/send');
                        final response = await http.post(url,
                            headers: {
                              'origin': 'http://localhost',
                              'Content-Type': 'application/json',
                            },
                            body: json.encode({
                              'service_id': 'service_smkqfxt',
                              'template_id': 'template_v2wk9kt',
                              'user_id': 'user_C3Qke9dPwz0OJgOyvnd4I',
                              'template_params': {
                                'username': id,
                                'password': data['password'],
                                'send_to': data['email'],
                              },
                            }));

                        print(response.body);
                      } else {
                        print('user does not exist');
                      }
                    });
                  });
                },
              ),
            ),
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
                        'conPass': confirmPass,
                      });
                      if (returnValue == 'username') {
                        errorExists = true;
                        errorText = 'Username already in use';
                        setState(() {});
                      } else if (returnValue == 'email') {
                        errorExists = true;
                        errorText = 'Email already in use';
                        setState(() {});
                      } else if (returnValue == 'password') {
                        errorText =
                            'Confirmation of password does not match entered password';
                        errorExists = true;
                        setState(() {});
                      } else {
                        errorExists = false;
                        pageFlag = false;
                        setState(() {});
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
