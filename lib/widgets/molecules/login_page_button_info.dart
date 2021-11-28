import 'package:flutter/material.dart';

class LoginPageButton extends StatelessWidget {
  const LoginPageButton({Key? key, required this.text, required this.icon})
      : super(key: key);

  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(text), icon],
    );
  }
}
