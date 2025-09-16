import 'package:flutter/material.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/views/widgets/my_text.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSizes.DEFAULT,
      child: Column(
        children: [
          const SizedBox(height: 60),
          MyText(text: 'Workout', weight: FontWeight.w700, size: 20),
        ],
      ),
    );
  }
}
