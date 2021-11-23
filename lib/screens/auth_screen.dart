import 'package:flutter/material.dart';
import 'package:snapmap/widgets/organisms/auth/login_form.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: LoginForm(),
    );
  }
}
