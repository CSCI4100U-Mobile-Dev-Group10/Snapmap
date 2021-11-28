import 'package:flutter/material.dart';

class TextButtonText extends StatelessWidget {
  const TextButtonText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(color: Color(0xFF7AB5B0)));
  }
}
