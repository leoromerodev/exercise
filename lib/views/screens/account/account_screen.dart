import 'package:flutter/material.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/views/widgets/my_text.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.defaultPadding,
      child: Column(
        children: [
          const SizedBox(height: 60),
          MyText(text: 'Account', weight: FontWeight.w700, size: 20),
        ],
      ),
    );
  }
}




