import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_sizes.dart';
import 'package:heavek/views/screens/workout/exercises_screen.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/screens/workout/exercise_wizard_screen_1.dart';

class WorkoutScreen extends StatelessWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSizes.defaultPadding,
        child: Column(
          children: [
            const SizedBox(height: 60),
            MyText(text: 'Workout', weight: FontWeight.w700, size: 20),
            const SizedBox(height: 40),

            // Create Exercise Button
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(() => const ExercisesScreen());
                },
                icon: const Icon(Icons.list_alt, color: kSecondaryColor),
                label: const Text(
                  'View All Exercises',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: kSecondaryColor),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button Alternative
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const ExerciseWizardScreen1(exerciseName: "Push-up"));
        },
        backgroundColor: kPrimaryColor,
        child: const Icon(Icons.fitness_center, color: kSecondaryColor),
      ),
    );
  }
}
