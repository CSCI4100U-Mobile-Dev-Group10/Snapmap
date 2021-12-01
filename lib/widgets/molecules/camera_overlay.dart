import 'package:flutter/material.dart';

class CameraOverlay extends StatelessWidget {
  const CameraOverlay(this.imageCallback, {Key? key}) : super(key: key);

  final void Function() imageCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.bottomCenter,
        child: ButtonBar(
          mainAxisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 48,
              icon: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: const BorderRadius.all(Radius.circular(24)),
                  border: Border.all(color: Colors.white, width: 5),
                ),
              ),
              onPressed: imageCallback,
            )
          ],
        ),
      ),
    );
  }
}
