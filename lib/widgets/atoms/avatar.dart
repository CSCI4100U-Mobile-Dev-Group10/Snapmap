import 'dart:io';

import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.path, {Key? key}) : super(key: key);
  final String path;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 55,
      backgroundColor: Colors.blue,
      child: Builder(builder: (BuildContext ctx) {
        if (path != '') {
          /// If the image is available, show it
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.file(
              File(path),
              width: 100,
              height: 100,
              fit: BoxFit.fitHeight,
            ),
          );
        } else {
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
        }
      }),
    );
  }
}
