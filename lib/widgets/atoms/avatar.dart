import 'dart:typed_data';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.imageUrl, {this.overrideBytes, this.radi = 55, Key? key})
      : super(key: key);
  final String imageUrl;
  final Uint8List? overrideBytes;
  final double radi;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radi,
      backgroundColor: const Color(0xFF12D39D),
      child: ClipOval(
        child: Builder(
          builder: (BuildContext ctx) {
            /// If the override image is not null, show it
            /// This is for the image picker
            if (overrideBytes != null) {
              return Image.memory(
                overrideBytes!,
                width: radi * 1.8,
                height: radi * 1.8,
              );
            }

            /// If the imageUrl isNotEmpty, show it
            if (imageUrl.isNotEmpty) {
              return Image.network(
                imageUrl,
                width: radi * 1.8,
                height: radi * 1.8,
              );
            }

            /// Fallback image if the user doesn't have an image selected
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(50),
              ),
              width: radi * 1.8,
              height: radi * 1.8,
              child: Icon(
                Icons.person,
                size: radi + 5,
                color: Colors.grey[800],
              ),
            );
          },
        ),
      ),
    );
  }
}
