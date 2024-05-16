import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditation_new/core/core.dart';

enum RoundedButtonType { primary, secondary }

class RoundedButton extends StatelessWidget {
  final String title;
  final RoundedButtonType type;
  final VoidCallback onPressed;
  const RoundedButton(
      {super.key,
      required this.title,
      required this.type,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: double.maxFinite,
          elevation: 0,
          color: type == RoundedButtonType.primary
              ? TColor.primary
              : TColor.secondary,
          height: 50.h,
          shape: RoundedRectangleBorder(
              side: BorderSide.none, borderRadius: BorderRadius.circular(30)),
          child: Text(
            title,
            style: TextStyle(
                color: type == RoundedButtonType.primary
                    ? Colors.white
                    : TColor.secondaryText,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600),
          ),
        ));
  }
}
