import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/controllers/auth_controller.dart';
import 'package:heavek/controllers/image_upload_controller.dart';
import 'package:heavek/models/user/user_model.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/screens/nav_bar/bottom_nav_bar.dart';
import 'package:heavek/views/widgets/common_image_view.dart';
import 'package:heavek/views/widgets/my_button.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_textfield.dart';
import 'package:intl/intl.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  // Get AuthController instance
  AuthController get authController => Get.find<AuthController>();
  
  // Get ImageUploadController instance
  ImageUploadController get imageUploadController => Get.find<ImageUploadController>();
  
  final _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocusNode = FocusNode();

  String? _usernameError;
  bool _isUsernameValid = false;

  @override
  void initState() {
    super.initState();

    _usernameFocusNode.addListener(() async {
      if (!_usernameFocusNode.hasFocus) {
        final username = authController.userNameController.text.trim();
        if (username.isEmpty) return;
        final isValid = await authController.checkUserName(userName: username);
        setState(() {
          _isUsernameValid = isValid;
          _usernameError = isValid ? null : "Invalid Username";
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    log('${userModelGlobal.value?.toMap()}');
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Padding(
            padding: AppSizes.defaultPadding,
            child: SingleChildScrollView(
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
                  const SizedBox(height: 35),

                  Obx(() => Stack(
                    children: [
                      Container(
                        width: 86,
                        height: 86,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                            color: Color(0XFFE1E1E1),
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: imageUploadController.currentImageFile != null
                            ? CommonImageView(
                                file: imageUploadController.currentImageFile,
                                height: 86,
                                width: 86,
                                isUploadable: true,
                                isCircular: true,
                                onTap: () => imageUploadController.showTestImagePickerBottomSheet(context),
                              )
                            : GestureDetector(
                                onTap: () => imageUploadController.showTestImagePickerBottomSheet(context),
                                child: Container(
                                  height: 86,
                                  width: 86,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF4A739C).withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color(0xFF4A739C).withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person_add_rounded,
                                    size: 36,
                                    color: Color(0xFF4A739C).withValues(alpha: 0.6),
                                  ),
                                ),
                              ),
                      ),
                      // Upload indicator overlay
                      if (imageUploadController.isProcessing)
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
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
                  )),
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: authController.firstNameController,
                    hint: 'First Name',
                    prefix: Padding(
                      padding: EdgeInsets.all(14),
                      child: CommonImageView(
                        imagePath: Assets.imagesUserIcon,
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    validator: (value) =>
                        validationService.emptyValidator(value),
                  ),
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: authController.lastNameController,
                    hint: 'Last Name',
                    prefix: Padding(
                      padding: EdgeInsets.all(14),
                      child: CommonImageView(
                        imagePath: Assets.imagesUserIcon,
                        height: 20,
                        width: 20,
                        fit: BoxFit.cover,
                      ),
                    ),
                    validator: (value) =>
                        validationService.emptyValidator(value),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: authController.userNameController,
                    focusNode: _usernameFocusNode,
                    decoration: InputDecoration(
                      hintText: "Username",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: kHintColor,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFonts.montserrat,
                      ),
                      isDense: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(14),
                        child: CommonImageView(
                          imagePath: Assets.imagesUserNameIcon,
                          height: 20,
                          width: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                      errorText: _usernameError,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: _isUsernameValid
                              ? Colors.green
                              : Color(0xff4A739C).withValues(alpha: 0.14),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(
                          color: _isUsernameValid
                              ? Colors.green
                              : Color(0xff4A739C).withValues(alpha: 0.14),
                          width: 1,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: BorderSide(color: Colors.red, width: 1),
                      ),
                    ),
                  ),

                  Obx(
                    () => authController.isLoading.value
                        ? Padding(
                            padding: EdgeInsets.only(top: 6),
                            child: LinearProgressIndicator(minHeight: 2),
                          )
                        : SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: authController.phoneNumController,
                    hint: 'Phone',
                    keyboardType: TextInputType.phone,
                    prefix: Padding(
                      padding: EdgeInsets.all(14),
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
                      padding: EdgeInsets.all(14),
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
                        if (!_isUsernameValid) {
                          customSnackBars.showFailureSnackBar(
                            title: 'Error',
                            message: 'Please enter a valid username',
                          );
                          return;
                        }

                        if (authController.dobController.text.trim().isEmpty ||
                            authController.selectedDate == null) {
                          customSnackBars.showFailureSnackBar(
                            title: 'Error',
                            message: 'Date of Birth is required',
                          );
                          return;
                        }

                        // Use uploaded image base64 string if available, otherwise use default URL
                        // The base64 string includes the data URL prefix: "data:image/jpeg;base64," + base64
                        String profileImageUrl = imageUploadController.hasUploadedImage
                            ? imageUploadController.getBase64String(includeDataUrlPrefix: true)
                            : '';

                        final user = UserModel(
                          id: userModelGlobal.value?.id,
                          profileImage: profileImageUrl,
                          screenName: authController.userNameController.text
                              .trim(),
                          firstName: authController.firstNameController.text
                              .trim(),
                          lastName: authController.lastNameController.text
                              .trim(),
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




