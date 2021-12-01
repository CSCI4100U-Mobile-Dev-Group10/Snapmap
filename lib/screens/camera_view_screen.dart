import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:snapmap/widgets/organisms/camera_view.dart';

class CameraViewScreen extends StatelessWidget {
  const CameraViewScreen({Key? key}) : super(key: key);

  void pictureCallback(Uint8List bytes) {
    // TODO show the createPost Dialog
  }

  void addFriendCallback(String username) {
    // TODO show the addFriendDialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CameraView(
        pictureCallback,
        addFriendCallback: addFriendCallback,
      ),
    );
  }
}
