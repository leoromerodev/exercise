import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:heavek/constants/app_colors.dart";
import "package:heavek/constants/app_images.dart";
import "package:heavek/views/widgets/my_text.dart";

class CustomSnackBars {
  // Private constructor
  CustomSnackBars._privateConstructor();

  // Singleton instance variable
  static CustomSnackBars? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to CustomSnackBars.instance will return the same instance that was created before.

  // Getter to access the singleton instance
  static CustomSnackBars get instance {
    _instance ??= CustomSnackBars._privateConstructor();
    return _instance!;
  }

  void showSuccessSnackBar({
    required String title,
    required String message,
    int durationSeconds = 2,
  }) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: durationSeconds),
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(30),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      titleText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              MyText(
                paddingLeft: 10,
                text: title,
                color: kSecondaryColor,
                size: 14,
                weight: FontWeight.w600,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.closeCurrentSnackbar();
            },
            child: Icon(Icons.cancel, color: Colors.grey),
          ),
        ],
      ),
      messageText: MyText(
        paddingLeft: 10,
        text: message,
        color: Colors.black,
        size: 11,
        weight: FontWeight.w400,
      ),
      icon: Image.asset(Assets.imagesDoneIcon),
    );
  }

  void showFailureSnackBar({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(30),
      boxShadows: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
      titleText: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              MyText(
                paddingLeft: 10,
                text: title,
                color: Colors.red,
                size: 14,
                weight: FontWeight.w600,
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Get.closeCurrentSnackbar();
            },
            child: Icon(Icons.cancel, color: Colors.grey),
          ),
        ],
      ),
      messageText: MyText(
        paddingLeft: 10,
        text: message,
        color: Colors.black,
        size: 11,
        weight: FontWeight.w400,
      ),
      icon: Image.asset(Assets.imagesWarningIcon),
    );
  }
}
