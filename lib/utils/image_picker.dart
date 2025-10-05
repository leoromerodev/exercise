import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heavek/utils/custom_snackbars.dart';
import 'package:heavek/views/widgets/image_picker_bottomsheet.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  ImagePickerService._privateConstructor();

  static ImagePickerService? _instance;

  static ImagePickerService get instance {
    _instance ??= ImagePickerService._privateConstructor();
    return _instance!;
  }

  Future<XFile?> pickImageFromCamera() async {
    try {
      XFile? imgXFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
      );
      if (imgXFile == null) {
        return null;
      } else {
        return imgXFile;
      }
    } on PlatformException catch (e) {
      log("This was the platform exception while selecting image: $e");

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Error Occurred",
        message: "Something went wrong, please try again",
      );

      return null;
    } catch (e) {
      log("This was the exception while selecting image: $e");

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Error Occurred",
        message: "Something went wrong, please try again",
      );

      return null;
    }
  }

  Future<XFile?> pickSingleImageFromGallery() async {
    try {
      XFile? imgXFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );
      if (imgXFile == null) {
        return null;
      }

      return imgXFile;
    } on PlatformException catch (e) {
      log("This was the exception while selecting image: $e");

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Error Occurred",
        message: "Something went wrong, please try again",
      );

      return null;
    } catch (e) {
      log("This was the exception while selecting image: $e");

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Error Occurred",
        message: "Something went wrong, please try again",
      );

      return null;
    }
  }

  Future<List<XFile>> pickMultiImagesFromGallery() async {
    try {
      List<XFile> pickedImages = await ImagePicker().pickMultiImage(
        imageQuality: 50,
      );
      if (pickedImages.isEmpty) {
        return [];
      }

      return pickedImages;
    } on PlatformException catch (e) {
      log("This was the exception while selecting image: $e");

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Error Occurred",
        message: "Something went wrong, please try again",
      );

      return [];
    } catch (e) {
      log("This was the exception while selecting image: $e");

      CustomSnackBars.instance.showFailureSnackBar(
        title: "Error Occurred",
        message: "Something went wrong, please try again",
      );

      return [];
    }
  }

  void openProfilePickerBottomSheet({
    required BuildContext context,
    required VoidCallback onCameraPick,
    required VoidCallback onGalleryPick,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0,
      builder: (_) {
        return ImagePickerBottomSheet(
          onCameraPick: onCameraPick,
          onGalleryPick: onGalleryPick,
        );
      },
    );
  }
}
