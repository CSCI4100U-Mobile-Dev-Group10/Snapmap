// ignore_for_file: prefer_const_constructors, avoid_print, avoid_single_cascade_in_expression_statements, invalid_return_type_for_catch_error

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:snapmap/screens/profile_creation.dart';
import 'package:snapmap/services/email_service.dart';
import 'package:snapmap/services/auth_service.dart';
import 'package:snapmap/globals.dart';


// login form first page of the application

class LoginForm extends StatefulWidget {
  LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
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
                  // check to see if email for sign up is valid
                  if (value == null || value.isEmpty) {
                    return 'This field needs input';
                  } else if (!emailValidator(value)) {
                    return 'Enter valid email';
                  } else {
                    return null;
                  }
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
                    // check to see if recovery email is in database
                    // if true send recovery email to address
                    await users
                        .where('email', isEqualTo: emailAlert)
                        .get()
                        .then((emailInstance) async {
                      if (emailInstance.docs.isNotEmpty) {
                        var data = emailInstance.docs.first.data() as Map;
                        var id = emailInstance.docs.single.id;
                        sendEmail(
                            username: id,
                            password: data['password'],
                            email: data['email']);
                      } else {
                        print('user does not exist');
                      }
                    }).catchError((_) => print(_));
                  });
                },
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (!pageFlag) {
                      // authorize user login
                      var returnValue = await authUser({
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
                        Navigator.pushNamed(context, '/controller');
                      }
                    } else {
                      // add users sign up info to database
                      var returnValue = await signUp({
                        'username': username,
                        'email': email,
                        'password': password,
                        'conPass': confirmPass,
                      });
                      user.username = username;
                      user.email = email;
                      user.password = password;
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
                        Navigator.pushNamed(context, '/profileCreation');
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