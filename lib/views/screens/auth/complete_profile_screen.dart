import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/models/user/user_model.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/screens/nav_bar/bottom_nav_bar.dart';
import 'package:heavek/views/widgets/common_image_view.dart';
import 'package:heavek/views/widgets/my_button.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_textfield.dart';
import 'package:intl/intl.dart';

class CompleteProfileScreen extends StatelessWidget {
  CompleteProfileScreen({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log('${userModelGlobal.value?.toMap()}');
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: AppSizes.DEFAULT,
          child: Column(
            children: [
              const SizedBox(height: 60),
              Center(
                child: MyText(
                  text: 'Complete your profile',
                  weight: FontWeight.w700,
                  size: 20,
                ),
              ),
              SizedBox(height: 35),
              Stack(
                children: [
                  Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Color(0XFFE1E1E1)),
                      shape: BoxShape.circle,
                    ),
                    child: CommonImageView(
                      imagePath: Assets.imagesDummyPlaceholder,
                      height: 80,
                      width: 80,
                    ),
                  ),
                  Positioned(
                    bottom: 10,
                    right: 0,
                    child: CommonImageView(
                      imagePath: Assets.imagesEditButton,
                      height: 22,
                      width: 22,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: authController.firstNameController,
                hint: 'First Name',
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesUserIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                validator: (value) =>
                    validationService.userNameValidator(value),
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: authController.lastNameController,
                hint: 'Last Name',
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesUserIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                validator: (value) =>
                    validationService.userNameValidator(value),
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: authController.userNameController,
                hint: 'Username',
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesUserNameIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                validator: (value) =>
                    validationService.userNameValidator(value),
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: authController.phoneNumController,
                hint: 'Phone',
                keyboardType: TextInputType.phone,
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesPhoneIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: authController.dobController,
                hint: 'Date of birth',
                onTap: () async {
                  await _showDatePicker(context);
                },
                readOnly: true,
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesDobIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              MyButton(
                buttonText: 'Save',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    if (authController.dobController.text.trim().isEmpty ||
                        authController.selectedDate == null) {
                      customSnackBars.showFailureSnackBar(
                        title: 'Error',
                        message: 'Date of Birth is required',
                      );
                    } else {
                      final user = UserModel(
                        id: userModelGlobal.value?.id,
                        profileImage:
                            'https://firebasestorage.googleapis.com/v0/b/catalyst-fcbf0.firebasestorage.app/o/images%2Fscaled_1000006597.jpg?alt=media&token=c96613ab-f64c-467e-9f29-8a8e56d10d77',
                        screenName: authController.userNameController.text
                            .trim(),
                        firstName: authController.firstNameController.text
                            .trim(),
                        lastName: authController.lastNameController.text.trim(),
                        birthday: authController.selectedDate,
                        email: EmailModel(
                          allowEmailNotifications: userModelGlobal
                              .value
                              ?.email
                              ?.allowEmailNotifications,
                          emailIsVerified:
                              userModelGlobal.value?.email?.emailIsVerified,
                          emailAddress: authController.emailController.text
                              .trim(),
                        ),
                      );

                      log('${user.toMap()}');
                      await authController.completeUserProfile(
                        context: context,
                        user: user,
                      );
                    }
                  }
                },
                radius: 5,
              ),
              const SizedBox(height: 24),
              MyText(
                text: ' Skip',
                color: kLightTextColor,
                weight: FontWeight.w500,
                size: 14,
                onTap: () {
                  Get.offAll(() => BottomNavBar());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Container(child: child);
      },
    ).then((value) {
      if (value != null) {
        authController.selectedDate = value;
        authController.dobController.text = DateFormat(
          'MMM d, yyyy',
        ).format(value);
      }
    });
  }
}
