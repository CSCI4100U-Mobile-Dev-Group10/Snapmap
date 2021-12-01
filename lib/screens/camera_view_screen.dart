import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snapmap/services/post_service.dart';
import 'package:snapmap/widgets/organisms/camera_view.dart';
import 'package:snapmap/widgets/organisms/friend_request_dialog.dart';
import 'package:snapmap/widgets/organisms/post_confirmation_dialog.dart';

class CameraViewScreen extends StatelessWidget {
  const CameraViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void pictureCallback(Uint8List bytes) {
      // TODO show the createPost Dialog
      showDialog(
        context: context,
        builder: (_) => PostConfirmationDialog(bytes),
      );
    }

    void addFriendCallback(String username) {
      // TODO show the addFriendDialog
      showDialog(
        context: context,
        builder: (_) => FriendRequestDialog(username),
      );
    }

    return Scaffold(
      body: CameraView(
        pictureCallback,
        addFriendCallback: addFriendCallback,
      ),
    );
  }
}
