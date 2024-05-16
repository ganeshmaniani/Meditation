import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/core.dart';

class AppBarForAdditional extends StatelessWidget {
  final String title;
  final bool isViewScreen;
  const AppBarForAdditional(
      {super.key, required this.title, this.isViewScreen = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 50, left: 16, right: 20, bottom: 20),
      width: double.infinity,
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          gradient: LinearGradient(
              colors: [Color(0xff886ff2), Color(0xff6849ef)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: isViewScreen
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              isViewScreen
                  ? const SizedBox()
                  : IconButton(
                      icon: Icon(Icons.arrow_back, color: TColor.primaryTextW),
                      onPressed: () => Navigator.pop(context)),
              SizedBox(width: 8.w),
              Text(
                title,
                style: isViewScreen
                    ? TextStyle(
                        color: TColor.primaryTextW,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold)
                    : TextStyle(
                        color: TColor.primaryTextW,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
