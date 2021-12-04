import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snapmap/models/exceptions/permissions_exception.dart';
import 'package:snapmap/services/post_service.dart';
import 'package:snapmap/widgets/atoms/dialog_base.dart';
import 'package:snapmap/widgets/molecules/error_dialog.dart';

class PostConfirmationDialog extends StatelessWidget {
  const PostConfirmationDialog(this.bytes, {Key? key}) : super(key: key);
  final Uint8List bytes;

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: const Text('Are you sure you want to post this?'),
      content: Image.memory(bytes),
      callback: () async {
        try {
          await PostService.getInstance().uploadPost(bytes);
        } on PermissionsException {
          showDialog(
            context: context,
            builder: (_) => const ErrorDialog(
              title: 'Error!',
              content: 'Location permissions must be enabled to post.',
            ),
          );
        }
      },
    );
  }
}
