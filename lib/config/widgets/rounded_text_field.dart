import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meditation_new/core/core.dart';

class RoundedTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? type;
  final bool? obscureText;
  final int maxLine;
  final Widget? right;
  const RoundedTextField(
      {super.key,
      required this.controller,
      this.type,
      this.obscureText,
      this.right,
      this.maxLine = 1,
      required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: maxLine == 1 ? 50.h : null,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          color: TColor.primaryTextW, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        maxLines: maxLine,
        // validator: (value) {
        //   if (value!.isEmpty) {
        //     return "This field is required";
        //   }
        //   return null;
        // },
        obscureText: obscureText ?? false,
        style: TextStyle(color: TColor.primaryText, fontSize: 16.sp),
        decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(color: TColor.secondaryText, fontSize: 16.sp),
            suffixIcon: right),
      ),
    );
  }
}
