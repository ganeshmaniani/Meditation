import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:typed_data/typed_data.dart';

class CustomBackGround extends StatelessWidget {
  final String image;
  final Widget child;

  final Uint8List? playImage;

  const CustomBackGround(
      {super.key, required this.image, required this.child, this.playImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage(image), fit: BoxFit.cover)),
      child: child,
    );
  }
}
