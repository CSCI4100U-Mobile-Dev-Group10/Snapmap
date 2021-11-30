import 'package:flutter/material.dart';

class LoginPageButton extends StatelessWidget {
  // need text and icon to be passed as parameters
  const LoginPageButton({Key? key, required this.text, required this.icon})
      : super(key: key);

  final String text;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    // create a row for text + icon displayed in button
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(text), icon],
    );
  }
}
