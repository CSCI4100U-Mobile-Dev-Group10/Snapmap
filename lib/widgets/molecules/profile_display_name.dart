import 'package:flutter/material.dart';

class DisplayNameWidget extends StatelessWidget {
  // pass username and display name as parameters
  const DisplayNameWidget(
      {Key? key,
      required this.username,
      required this.displayName,
      this.textMult})
      : super(key: key);

  final String username, displayName;
  final double? textMult;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          displayName,
          style: TextStyle(
            fontSize: 5 * (textMult ?? 5),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '@$username',
          style: TextStyle(
            fontSize: 4 * (textMult ?? 5),
            color: Colors.black38,
          ),
        ),
      ],
    );
  }
}
