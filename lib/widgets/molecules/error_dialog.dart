import 'package:flutter/material.dart';
import 'package:snapmap/widgets/atoms/dialog_base.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return DialogBase(
      title: Text(title),
      content: Text(content),
      callback: () async {
        Navigator.of(context).pop();
      },
      showCancel: false,
    );
  }
}
