import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/controllers/auth_controller.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/screens/auth/login_screen.dart';
import 'package:heavek/views/widgets/common_image_view.dart';
import 'package:heavek/views/widgets/my_button.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_textfield.dart';

class SignupScreen extends StatelessWidget {
  final bool fromMain;
  SignupScreen({required this.fromMain, super.key});
  
  // Get AuthController instance
  AuthController get authController => Get.find<AuthController>();
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSizes.defaultPadding,
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: MyText(
                text: 'Create an account',
                weight: FontWeight.w700,
                size: 20,
              ),
            ),
            SizedBox(height: 35),
            Form(
              key: _formKey,
              child: MyTextfield(
                controller: authController.emailController,
                hint: 'test@email.com',
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesEmailIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                validator: (value) => validationService.emailValidator(value),
              ),
            ),
            SizedBox(height: 40),
            MyButton(
              buttonText: 'Sign Up',
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await authController.checkAccountStatus(
                    email: authController.emailController.text.trim(),
                    context: context,
                  );
                }
              },
              radius: 5,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyText(
                  text: ' Already have an account? ',
                  color: kLightTextColor,
                  weight: FontWeight.w500,
                  size: 14,
                ),
                MyText(
                  text: 'Login',
                  color: kHighlightColor,
                  weight: FontWeight.w500,
                  size: 14,
                  onTap: () {
                    fromMain ? Get.off(() => LoginScreen()) : Get.back();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




