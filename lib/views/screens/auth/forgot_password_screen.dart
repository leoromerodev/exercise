import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/screens/auth/forgot_password_verification_screen.dart';
import 'package:heavek/views/screens/auth/verification_screen.dart';
import 'package:heavek/views/widgets/common_image_view.dart';
import 'package:heavek/views/widgets/my_button.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSizes.DEFAULT,
        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: MyText(
                text: 'Forgot Password?',
                weight: FontWeight.w700,
                size: 20,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: MyText(
                text: 'Enter your email address to get the verification code.',
                weight: FontWeight.w500,
                size: 14,
                color: kLightTextColor,
                textAlign: TextAlign.center,
                paddingLeft: 60,
                paddingRight: 60,
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
            const SizedBox(height: 50),
            MyButton(
              buttonText: 'Send Code',
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await authController.sendForgetPasswordEmail(
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
                  text: ' Do you remember your password? ',
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
                    Get.back();
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
