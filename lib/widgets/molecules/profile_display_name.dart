import 'package:flutter/material.dart';

class DisplayNameWidget extends StatelessWidget {
  // pass username and display name as parameters
  const DisplayNameWidget(
      {Key? key, required this.username, required this.displayName})
      : super(key: key);

  final String username, displayName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(username,
            style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        Text('@$displayName',
            style: const TextStyle(fontSize: 20, color: Colors.black38)),
      ],
    );
  }
}
