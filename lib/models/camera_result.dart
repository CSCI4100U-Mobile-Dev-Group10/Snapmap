import 'dart:typed_data';

class CameraResult {
  bool isQrCode;
  String? qrData;
  Uint8List image;

  CameraResult(
    this.image, {
    this.isQrCode = false,
    this.qrData,
  });
}
