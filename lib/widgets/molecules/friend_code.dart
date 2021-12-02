import 'package:flutter/material.dart';
import 'package:snapmap/models/user.dart';
import 'package:snapmap/widgets/atoms/qr.dart';
import 'package:snapmap/services/qr_service.dart';

class FriendCode extends StatelessWidget {
  const FriendCode(this.user, {Key? key}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Center(child: QRCode(qrCode: generateQRCode()));
  }
}
