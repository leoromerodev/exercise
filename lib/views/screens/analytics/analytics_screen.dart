import 'package:flutter/material.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/views/widgets/my_text.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.DEFAULT,
      child: Column(
        children: [
          const SizedBox(height: 60),
          MyText(text: 'Analytics', weight: FontWeight.w700, size: 20),
        ],
      ),
    );
  }
}
