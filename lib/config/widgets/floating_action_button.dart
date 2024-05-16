import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';

class CustomFAButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const CustomFAButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      elevation: 0,
      label: Text(buttonText,
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: TColor.primaryText)),
      onPressed: onPressed,
      backgroundColor: Colors.white,
    );
  }
}
