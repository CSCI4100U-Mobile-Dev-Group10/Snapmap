import 'package:camera/camera.dart';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:snapmap/services/qr_service.dart';
import 'package:snapmap/utils/logger.dart';

class CameraService {
  /// Singleton for this class
  CameraService._();
  static final CameraService _singleton = CameraService._();
  factory CameraService.getInstance() => _singleton;

  List<CameraDescription> cameras = [];

  Future<void> loadCameras() async {
    cameras = await availableCameras();
  }

  static Future<CameraResult> processImage(XFile imageFile) async {
    Uint8List bytes = await imageFile.readAsBytes();
    String? qrscan;

    try {
      qrscan = await scanner.scanBytes(bytes);
    } catch (_) {
      logger.i('no qr code detected');
    }

    return CameraResult(bytes, QrResult(qrscan));
  }
}

class CameraResult {
  QrResult qrData;
  Uint8List image;

  CameraResult(this.image, this.qrData);
}
