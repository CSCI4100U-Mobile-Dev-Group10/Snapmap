import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCode extends StatelessWidget {
  // need to pass the friend code of a user as a parameter
  const QRCode({Key? key, required this.qrCode}) : super(key: key);
  final String qrCode;

  @override
  Widget build(BuildContext context) {
    return QrImage(
      data: qrCode,
      dataModuleStyle: const QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.square,
        color: Color(0xFF0EA47A),
      ),
      eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square, color: Color(0xFF0EA47A)),
      version: QrVersions.auto,
      size: 280,
      gapless: false,
      errorStateBuilder: (cxt, err) {
        return const Center(
          child: Text(
            "Oops! It looks like something went wrong...",
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
