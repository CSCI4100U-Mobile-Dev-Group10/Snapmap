import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  const WelcomeSection(
      {Key? key, required this.message, required this.information})
      : super(key: key);

  final String message, information;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(message,
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(information,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black54))
      ],
    );
  }
}
