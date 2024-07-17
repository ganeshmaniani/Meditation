import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/widgets/widgets.dart';

class CustomTimePicker extends StatefulWidget {
  final Function(Duration) onDurationSelected;

  const CustomTimePicker({required this.onDurationSelected});

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  int selectedHour = 0;
  int selectedMinute = 0;
  int selectedSecond = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: 250.h,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Select Duration', style: TextStyle(fontSize: 18.sp)),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNumberPicker('Hours', 0, 23, selectedHour, (value) {
                  setState(() {
                    selectedHour = value;
                  });
                }),
                _buildNumberPicker('Minutes', 0, 59, selectedMinute, (value) {
                  setState(() {
                    selectedMinute = value;
                  });
                }),
                _buildNumberPicker('Seconds', 0, 59, selectedSecond, (value) {
                  setState(() {
                    selectedSecond = value;
                  });
                }),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 40.h,
                child: RoundedButton(
                    title: "Confirm",
                    type: RoundedButtonType.primary,
                    onPressed: () {
                      final duration = Duration(
                        hours: selectedHour,
                        minutes: selectedMinute,
                        seconds: selectedSecond,
                      );
                      widget.onDurationSelected(duration);
                      Navigator.of(context).pop();
                    })),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPicker(String label, int minValue, int maxValue,
      int selectedValue, Function(int) onChanged) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp)),
        SizedBox(
          height: 100.h,
          width: 50.w,
          child: ListWheelScrollView(
            itemExtent: 30,
            magnification: 1.5,
            useMagnifier: true,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            children: List.generate(
                maxValue - minValue + 1,
                (index) => Text('${minValue + index}',
                    style: TextStyle(fontSize: 20.sp))),
          ),
        ),
      ],
    );
  }
}
