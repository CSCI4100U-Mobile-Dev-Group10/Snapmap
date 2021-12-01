import 'package:flutter/material.dart';

class DialogBase extends StatefulWidget {
  const DialogBase({
    required this.title,
    required this.content,
    required this.callback,
    Key? key,
  }) : super(key: key);

  final Widget title;
  final Widget content;
  final Future<void> Function() callback;

  @override
  State<DialogBase> createState() => _DialogBaseState();
}

class _DialogBaseState extends State<DialogBase> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    if (isAccepted) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return AlertDialog(
      title: widget.title,
      content: widget.content,
      actions: [
        IconButton(
          icon: const Icon(Icons.cancel_rounded, color: Colors.redAccent),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        IconButton(
          icon: const Icon(Icons.check, color: Colors.green),
          onPressed: () async {
            if (!isAccepted) {
              setState(() {
                isAccepted = true;
              });
              await widget.callback();
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
