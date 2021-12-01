import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snapmap/services/post_service.dart';

class PostConfirmationDialog extends StatelessWidget {
  const PostConfirmationDialog(this.bytes, {Key? key}) : super(key: key);
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure you want to post this?'),
      content: Image.memory(bytes),
      actions: [
        IconButton(
          icon: const Icon(Icons.cancel_rounded, color: Colors.redAccent),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green),
          onPressed: () async {
            await PostService.getInstance().uploadPost(bytes);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
