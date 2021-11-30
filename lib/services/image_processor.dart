import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:snapmap/models/camera_result.dart';
import 'package:qrscan/qrscan.dart' as scanner;

Future<CameraResult> processImage(XFile imageFile) async {
  Uint8List bytes = await imageFile.readAsBytes();
  String? qrscan = await scanner.scan();

  return CameraResult(
    bytes,
    isQrCode: (qrscan != null),
    qrData: qrscan,
  );
}
