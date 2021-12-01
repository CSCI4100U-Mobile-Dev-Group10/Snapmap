import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snapmap/services/post_service.dart';
import 'package:snapmap/widgets/atoms/dialog_base.dart';

class PostConfirmationDialog extends StatelessWidget {
  const PostConfirmationDialog(this.bytes, {Key? key}) : super(key: key);
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: const Text('Are you sure you want to post this?'),
      content: Image.memory(bytes),
      callback: () async {
        await PostService.getInstance().uploadPost(bytes);
      },
    );
  }
}
