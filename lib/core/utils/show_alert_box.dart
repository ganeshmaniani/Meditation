import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

showAlertBox(BuildContext context,{required VoidCallback btnOkOnPress,required VoidCallback btnCancelOnPress}) {
  return AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.topSlide,
          btnOkOnPress: btnOkOnPress,

          btnCancelOnPress: btnCancelOnPress,
          title: 'Delete Confirmation',
          desc: 'Are you sure you want to delete')
      .show();
}
