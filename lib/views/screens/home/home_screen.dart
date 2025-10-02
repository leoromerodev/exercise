import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/controllers/auth_controller.dart';
import 'package:heavek/views/widgets/my_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  
  // Get AuthController instance
  AuthController get authController => Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.DEFAULT,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(text: 'Home', weight: FontWeight.w700, size: 20),
              GestureDetector(
                onTap: () async {
                  await authController.logout();
                },
                child: Icon(Icons.logout, color: kRedColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
