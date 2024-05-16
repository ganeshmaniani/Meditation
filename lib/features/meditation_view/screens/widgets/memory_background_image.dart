import 'dart:typed_data';

import 'package:flutter/material.dart';

class MemoryBackGroundImage extends StatelessWidget {
  final Widget child;

  final Uint8List playImage;

  const MemoryBackGroundImage(
      {super.key, required this.child, required this.playImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: MemoryImage(playImage), fit: BoxFit.cover)),
      child: child,
    );
  }
}
