import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/core.dart';

class CustomAppBar extends StatelessWidget {
  final Uint8List profileImage;
  final String greeting;
  final String userName;
  const CustomAppBar({
    super.key,
    required this.profileImage,
    required this.greeting,
    required this.userName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 80, left: 20, right: 20),
      height: 180.h,
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          gradient: LinearGradient(colors: [
            Color(0xff886ff2),
            Color(0xff6849ef),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              profileImage != null
                  ? Container(
                      height: 60.h,
                      width: 60.h,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.memory(profileImage))
                  : const SizedBox(),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello,",
                    style: TextStyle(
                        color: TColor.primaryTextW,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    greeting,
                    style: TextStyle(
                        color: TColor.primaryTextW,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                        color: TColor.primaryTextW,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            "We Wish you have a good day",
            style: TextStyle(color: TColor.tertiary, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }
}
