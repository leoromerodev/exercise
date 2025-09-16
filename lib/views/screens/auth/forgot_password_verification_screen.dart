import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/widgets/my_button.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:pinput/pinput.dart';

class ForgotPasswordVerificationScreen extends StatelessWidget {
  ForgotPasswordVerificationScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xff05212F).withOpacity(0.14)),
        borderRadius: BorderRadius.circular(12),
      ),
    );
    return Scaffold(
      body: Padding(
        padding: AppSizes.DEFAULT,

        child: Column(
          children: [
            const SizedBox(height: 60),
            Center(
              child: MyText(
                text: 'Enter your code',
                weight: FontWeight.w700,
                size: 20,
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: MyText(
                text: 'Enter the 6 digit code we have sent to your email.',
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
              child: Pinput(
                length: 6, // number of boxes
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.blue, width: 2),
                  ),
                ),
                submittedPinTheme: defaultPinTheme,
                // Set pre-filled value
                controller: authController.otpController,
                showCursor: true,
                validator: (value) => validationService.validateOtp(value),
              ),
            ),
            SizedBox(height: 40),

            MyButton(
              buttonText: 'Verify',
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await authController.verifyForgetPasswordOtp(
                    email: authController.emailController.text.trim(),
                    otp: authController.otpController.text.trim(),
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
                  text: 'Didn’t get the code? ',
                  color: kLightTextColor,
                  weight: FontWeight.w500,
                  size: 14,
                ),
                MyText(
                  text: 'Send Again',
                  color: kHighlightColor,
                  weight: FontWeight.w500,
                  size: 14,
                  onTap: () async {
                    await authController.resendForgetPasswordEmail(
                      email: authController.emailController.text.trim(),
                      context: context,
                    );
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
