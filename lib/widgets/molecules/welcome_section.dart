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
            style: const TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        // provides extra information for the user
        const SizedBox(height: 5),
        Text(information,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54)),

        const SizedBox(height: 10),
      ],
    );
  }
}
