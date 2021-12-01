import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snapmap/services/post_service.dart';

class PostConfirmationDialog extends StatefulWidget {
  const PostConfirmationDialog(this.bytes, {Key? key}) : super(key: key);
  final Uint8List bytes;

  @override
  State<PostConfirmationDialog> createState() => _PostConfirmationDialogState();
}

class _PostConfirmationDialogState extends State<PostConfirmationDialog> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    if (isAccepted) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return AlertDialog(
      title: const Text('Are you sure you want to post this?'),
      content: Image.memory(widget.bytes),
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
            if (!isAccepted) {
              setState(() {
                isAccepted = true;
              });
              await PostService.getInstance().uploadPost(widget.bytes);
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
