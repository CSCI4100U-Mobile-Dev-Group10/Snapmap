import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:snapmap/services/camera_service.dart';
import 'package:snapmap/services/qr_service.dart';
import 'package:snapmap/widgets/molecules/camera_overlay.dart';

class CameraView extends StatefulWidget {
  const CameraView(
    this.pictureCallback, {
    required this.addFriendCallback,
    Key? key,
  }) : super(key: key);

  final void Function(String) addFriendCallback;
  final void Function(Uint8List) pictureCallback;

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
        CameraService.getInstance().cameras[0], ResolutionPreset.max);
    _controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> imageCallback() async {
    XFile imageFile = await _controller!.takePicture();
    CameraResult result = await CameraService.processImage(imageFile);

    switch (result.qrData.operation) {
      case QrOperation.add:
        return widget.addFriendCallback(result.qrData.username);
      case QrOperation.none:
      default:
        return widget.pictureCallback(result.image);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!(_controller?.value.isInitialized ?? false)) {
      return Container();
    }

    return SizedBox.expand(
      child: CameraPreview(
        _controller!,
        child: CameraOverlay(imageCallback),
      ),
    );
  }
}
