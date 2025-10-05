import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/views/screens/auth/login_screen.dart';
import 'package:heavek/views/screens/auth/signup_screen.dart';
import 'package:heavek/views/widgets/common_image_view.dart';
import 'package:heavek/views/widgets/my_border_button.dart';
import 'package:heavek/views/widgets/my_button.dart';
import 'package:heavek/views/widgets/my_text.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Background full image
          Positioned.fill(
            child: Image.asset(Assets.imagesCoverImage, fit: BoxFit.cover),
          ),

          /// Shadow overlay at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: CommonImageView(
              imagePath: Assets.imagesShadowImage,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
          ),

          /// Content on top of shadow image
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: AppSizes.DEFAULT,
              child: Column(
                mainAxisSize: MainAxisSize.min, // only take needed height
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MyText(
                    text: 'Wherever You Are Health Is Number One',
                    weight: FontWeight.w700,
                    size: 24,
                    paddingBottom: 16,
                    textAlign: TextAlign.center,
                  ),
                  MyText(
                    text: 'There is no instant way to a healthy life',
                    color: kLightTextColor,
                    weight: FontWeight.w400,
                    size: 16,
                    paddingBottom: 40,
                    textAlign: TextAlign.center,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: MyButton(
                          radius: 5,
                          buttonText: 'Sign Up',
                          onTap: () {
                            Get.to(() => SignupScreen(fromMain: true,));
                          },
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: MyBorderButton(
                          radius: 5,
                          buttonText: 'Login',
                          onTap: () {
                            Get.to(() => LoginScreen());
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
