import 'package:flutter/material.dart';

class LoginDivider extends StatelessWidget {
  const LoginDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // stack a divider and text
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(thickness: 1.5, color: Color(0xFF12D39D)),
        // stack text on top of divider with padding to add some whitespace
        // between text and divider
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(2),
          child: const Text('OR', style: TextStyle(color: Color(0xFF12D39D))),
        ),
      ],
    );
  }
}
