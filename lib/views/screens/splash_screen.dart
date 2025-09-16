import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/views/screens/auth/auth_screen.dart';
import 'package:heavek/views/widgets/common_image_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((_) {
      Get.offAll(() => AuthScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSecondaryColor,
      body: Center(
        child: CommonImageView(
          imagePath: Assets.imagesLogoWithText,
          height: 206,
          width: 280,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
