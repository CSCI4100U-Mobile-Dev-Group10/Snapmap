import 'package:flutter/material.dart';

class WelcomeSection extends StatelessWidget {
  // pass welcome message and information as parameters
  const WelcomeSection(
      {Key? key, required this.message, required this.information})
      : super(key: key);

  final String message, information;

  @override
  Widget build(BuildContext context) {
    // build a column of two text widgets
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // provides a welcome message for the user
        Text(message,
            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        // provides extra information for the user
        Text(information,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black54))
      ],
    );
  }
}
