import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';

class DialogService {
  //singleton instance
  static DialogService get instance => DialogService();

  void showProgressDialog({required BuildContext context}) {
    log("showing progress indicator");
    //showing progress indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      // ignore: deprecated_member_use
      builder:
          (_) => WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Center(
              child: CircularProgressIndicator(color: kSecondaryColor),
            ),
          ),
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }

  Future<DateTime?> showDatePickerDialog(BuildContext context) {
    return showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2052),
      initialDate: DateTime(DateTime.now().year, DateTime.now().month),
    );
  }
}
