import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenderSelectionItem extends StatelessWidget {
  final String text;
  final String image;
  final Function(String) onSelect;

  const GenderSelectionItem({
    super.key,
    required this.text,
    required this.image,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => onSelect(text),
        child: Container(
          height: 50.h,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: TextStyle(fontSize: 18.sp),
              ),
              Image.asset(
                image,
                height: 26,
              )
            ],
          ),
        ),
      ),
    );
  }
}
