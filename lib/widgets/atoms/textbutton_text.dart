import 'package:flutter/material.dart';

class TextButtonText extends StatelessWidget {
  // need to pass the text of the button as parameter
  const TextButtonText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(color: Colors.blue));
  }
}
