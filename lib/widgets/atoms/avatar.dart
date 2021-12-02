import 'dart:typed_data';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.imageUrl, {this.overrideBytes, Key? key}) : super(key: key);
  final String imageUrl;
  final Uint8List? overrideBytes;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 55,
      backgroundColor: const Color(0xFF12D39D),
      child: ClipOval(
        child: Builder(
          builder: (BuildContext ctx) {
            /// If the override image is not null, show it
            /// This is for the image picker
            if (overrideBytes != null) {
              return Image.memory(
                overrideBytes!,
                width: 100,
                height: 100,
              );
            }

            /// If the imageUrl isNotEmpty, show it
            if (imageUrl.isNotEmpty) {
              return Image.network(
                imageUrl,
                width: 100,
                height: 100,
              );
            }

            /// Fallback image if the user doesn't have an image selected
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(50),
              ),
              width: 100,
              height: 100,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.grey[800],
              ),
            );
          },
        ),
      ),
    );
  }
}
