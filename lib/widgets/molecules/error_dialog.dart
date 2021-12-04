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
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF12D39D)),
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
