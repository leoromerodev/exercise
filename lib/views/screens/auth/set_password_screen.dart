import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/widgets/common_image_view.dart';
import 'package:heavek/views/widgets/my_button.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_textfield.dart';

class SetPasswordScreen extends StatelessWidget {
  SetPasswordScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  text: 'Enter New Password',
                  weight: FontWeight.w700,
                  size: 20,
                ),
              ),
              SizedBox(height: 35),
              MyTextfield(
                controller: authController.passwordController,
                hint: 'Password',
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesPasswordIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                suffix: Icon(
                  Icons.visibility_off_outlined,
                  color: Color(0xff7A8094),
                  size: 18,
                ),
                validator: (value) => validationService.validatePassword(value),
              ),
              const SizedBox(height: 10),
              MyText(
                text:
                    '*Password must have at least 8 characters, 1 capital letter, 1 number, and 1 symbol.',
                weight: FontWeight.w500,
                size: 11,
                color: kLightTextColor,
                paddingBottom: 20,
              ),
              MyTextfield(
                controller: authController.confirmPasswordController,
                hint: 'Re-type Password',
                prefix: Padding(
                  padding: EdgeInsetsGeometry.all(14),
                  child: CommonImageView(
                    imagePath: Assets.imagesPasswordIcon,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
                suffix: Icon(
                  Icons.visibility_off_outlined,
                  color: Color(0xff7A8094),
                  size: 18,
                ),
                validator: (value) => validationService.validateMatchPassword(
                  authController.passwordController.text.trim(),
                  value!,
                ),
              ),
              SizedBox(height: 35),
              MyButton(
                buttonText: 'Save',
                onTap: () async {
                  if (_formKey.currentState!.validate()) {
                    await authController.signupEmailPassword(
                      email: authController.emailController.text.trim(),
                      password: authController.passwordController.text.trim(),
                      context: context,
                    );
                  }
                },
                radius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
