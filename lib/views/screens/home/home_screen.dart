import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/utils/global_instances.dart';
import 'package:heavek/views/widgets/my_text.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
