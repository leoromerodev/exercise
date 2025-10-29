import 'package:flutter/material.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/views/widgets/my_text.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.defaultPadding,
      child: Column(
        children: [
          const SizedBox(height: 60),
          MyText(text: 'Records', weight: FontWeight.w700, size: 20),
        ],
      ),
    );
  }
}




