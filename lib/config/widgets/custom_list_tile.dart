import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/core.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final Uint8List? playlistImage;
  final String duration;
  final String? description;
  final bool isHome;
  final double vertical;
  final double horizontal;
  final bool isMoreVert;
  final Function(String)? onSelectedDelete;
  final VoidCallback? onTapEdit;
  final bool isNoMoreVertAndDelete;
  const CustomListTile(
      {super.key,
      required this.title,
      this.playlistImage,
      required this.duration,
      this.isHome = false,
      required this.vertical,
      this.horizontal = 16,
      required this.isMoreVert,
      this.onSelectedDelete,
      this.onTapEdit,
      this.isNoMoreVertAndDelete = false,
      this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: TColor.primaryTextW,
          borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        children: [
          isHome
              ? Container(
                  height: 50.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      image: DecorationImage(
                        image: MemoryImage(playlistImage!),
                        fit: BoxFit.cover,
                      )),
                )
              : Container(
                  height: 50.h,
                  width: 50.w,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: TColor.primary),
                  child: Icon(Icons.play_arrow,
                      color: TColor.primaryTextW, size: 30)),
          SizedBox(width: 8.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 4.w),
              isMoreVert
                  ? Text(description ?? "",
                      style: Theme.of(context).textTheme.bodyMedium)
                  : Wrap(
                      children: [
                        Text("Duration",
                            style: Theme.of(context).textTheme.bodyMedium),
                        SizedBox(width: 4.w),
                        Text("$duration Sec",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    )
            ],
          ),
          const Spacer(),
          isMoreVert
              ? PopupMenuButton(
                  color: Colors.white,
                  onSelected: onSelectedDelete,
                  icon: Icon(Icons.more_vert, color: TColor.secondary),
                  itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: 'Edit',
                          child: Row(
                            children: [
                              const Icon(Icons.edit),
                              const SizedBox(width: 8),
                              Text('Edit',
                                  style: TextStyle(color: TColor.secondary)),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'Delete',
                          child: Row(
                            children: [
                              const Icon(Icons.delete),
                              const SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: TColor.secondary)),
                            ],
                          ),
                        )
                      ])
              : isNoMoreVertAndDelete
                  ? const SizedBox()
                  : IconButton(
                      onPressed: onTapEdit,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
        ],
      ),
    );
  }
}
