import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/constants.dart';

class PlaylistImageContainer extends StatefulWidget {
  final String playListImage;
  final bool isSelected;
  final VoidCallback onTap;

  const PlaylistImageContainer({
    super.key,
    required this.playListImage,
    required this.isSelected,
    required this.onTap,
  });

  @override
  _PlaylistImageContainerState createState() => _PlaylistImageContainerState();
}

class _PlaylistImageContainerState extends State<PlaylistImageContainer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 50.h,
        width: 50.w,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: widget.isSelected
              ? Border.all(color: TColor.primary, width: 4)
              : null,
          image: DecorationImage(
            image: AssetImage(widget.playListImage),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
