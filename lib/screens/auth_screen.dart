import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:snapmap/services/users.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:snapmap/widgets/organisms/auth/login_form.dart';

class authentication extends StatefulWidget {
  const authentication({Key? key}) : super(key: key);

  @override
  _authenticationState createState() => _authenticationState();
}

class _authenticationState extends State<authentication> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: loginForm(),
    );
  }
}

