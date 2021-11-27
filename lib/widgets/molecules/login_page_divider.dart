import 'package:flutter/material.dart';

class LoginDivider extends StatelessWidget {
  const LoginDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Divider(thickness: 1, color: Color(0xFF7AB5B0)),
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          padding: const EdgeInsets.all(2),
          child: const Text('OR', style: TextStyle(color: Color(0xFF7AB5B0))),
        ),
      ],
    );
  }
}
