import 'package:flutter/material.dart';
import 'package:snapmap/widgets/organisms/auth/login_form.dart';

class AuthScreen extends StatefulWidget {
  static const String routeId = '/auth';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return const Card(child: LoginForm());
  }
}
