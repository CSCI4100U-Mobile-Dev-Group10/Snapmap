import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  const WelcomeMessage({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(message,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold));
  }
}
