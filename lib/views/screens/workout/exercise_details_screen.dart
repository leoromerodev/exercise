import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';

import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_border_button.dart';

enum ExerciseDetailsMode { preview, edit }

class ExerciseDetailsScreen extends StatefulWidget {
  final String exerciseName;
  final ExerciseDetailsMode mode;

  const ExerciseDetailsScreen({
    Key? key,
    required this.exerciseName,
    this.mode = ExerciseDetailsMode.edit,
  }) : super(key: key);

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor.withValues(alpha: 0.97),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        automaticallyImplyLeading: widget.mode == ExerciseDetailsMode.edit,
        leading: widget.mode == ExerciseDetailsMode.edit
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: kTextColorPrimary,
                ),
                onPressed: () => Get.back(),
              )
            : null,
        title: MyText(
          text: widget.exerciseName,
          size: 18,
          weight: AppFontWeight.bold,
          color: kTextColorPrimary,
          fontFamily: AppFonts.Montserrat,
        ),
        centerTitle: true,
        actions: widget.mode == ExerciseDetailsMode.preview
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: kTextColorPrimary),
                    onPressed: () => Get.back(),
                  ),
                ),
              ]
            : null,
        bottom: widget.mode == ExerciseDetailsMode.edit
            ? PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  height: 4.0,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: LinearProgressIndicator(
                    value: 1.0, // 8/8 = 100% complete
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      kTertiaryColor,
                    ),
                  ),
                ),
              )
            : null,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            Center(
              child: MyText(
                text: 'Exercise Details',
                size: 12,
                weight: AppFontWeight.medium,
                color: kTextColorPrimary,
                fontFamily: AppFonts.Montserrat,
              ),
            ),
            const SizedBox(height: 10.0),

            // Main Content Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: 'Exercise Information',
                    size: 18,
                    weight: AppFontWeight.semiBold,
                    color: kTextColorPrimary,
                    fontFamily: AppFonts.Montserrat,
                  ),
                  const SizedBox(height: 8),
                  MyText(
                    text: 'View detailed information about this exercise.',
                    size: 13,
                    weight: AppFontWeight.regular,
                    color: kTextColorSecondary,
                    fontFamily: AppFonts.OpenSans,
                  ),
                  const SizedBox(height: 20.0),

                  // Placeholder content - you can add exercise details here
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: kMediaUploadBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.fitness_center_outlined,
                            size: 48,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          MyText(
                            text: 'Exercise Details',
                            size: 14,
                            weight: AppFontWeight.medium,
                            color: Colors.grey[500]!,
                          ),
                          const SizedBox(height: 4),
                          MyText(
                            text: 'Content to be added',
                            size: 12,
                            weight: AppFontWeight.regular,
                            color: Colors.grey[400]!,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30.0),

            // Action Buttons (only show in edit mode)
            if (widget.mode == ExerciseDetailsMode.edit)
              Column(
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () => _onPublishExercise(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kSecondaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: MyText(
                          text: 'Publish',
                          size: 16,
                          weight: FontWeight.w600,
                          color: kPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: MyBorderButton(
                        buttonText: 'Cancel',
                        onTap: () => Get.back(),
                        borderColor: kSecondaryColor,
                        textColor: kSecondaryColor,
                        radius: 15,
                        height: 56,
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  void _onPublishExercise() {
    // Handle publish exercise action
    // Save the exercise and navigate back
  }
}
