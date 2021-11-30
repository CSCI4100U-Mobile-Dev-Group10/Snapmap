import 'package:flutter/material.dart';

class TextButtonText extends StatelessWidget {
  // need to pass the text of the button as parameter
  const TextButtonText({Key? key, required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    // set button to match colour of image in title
    return Text(text, style: TextStyle(color: Color(0xFF7AB5B0)));
  }
}
