import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';

import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_border_button.dart';
import 'package:heavek/views/widgets/training_categories_selector.dart';
import 'package:heavek/views/widgets/movement_pattern_selector.dart';
import 'exercise_details_screen.dart';
import 'exercise_wizard_screen_3.dart';

class ExerciseWizardScreen2 extends StatefulWidget {
  final String exerciseName;
  final Map<String, dynamic>? previousData;

  const ExerciseWizardScreen2({
    Key? key,
    required this.exerciseName,
    this.previousData,
  }) : super(key: key);

  @override
  State<ExerciseWizardScreen2> createState() => _ExerciseWizardScreen2State();
}

class _ExerciseWizardScreen2State extends State<ExerciseWizardScreen2> {
  // Selection storage for the training categories
  Map<String, Set<String>> selectedTrainings = {};
  Map<String, Set<String>> selectedTechniques = {};

  // Selection storage for movement patterns
  Set<String> selectedMovementPatterns = {};

  // Toggle states for exercise properties
  bool isWarmUpFriendly = false;
  bool isCoolDownFriendly = false;

  void _onSelectionChanged(
    Map<String, Set<String>> trainings,
    Map<String, Set<String>> techniques,
  ) {
    setState(() {
      selectedTrainings = trainings;
      selectedTechniques = techniques;
    });
  }

  void _onMovementPatternChanged(Set<String> patterns) {
    setState(() {
      selectedMovementPatterns = patterns;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor.withValues(alpha: 0.97),
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        elevation: 4,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.black.withValues(alpha: 0.2),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: kTextColorPrimary),
          onPressed: () => Get.back(),
        ),
        title: MyText(
          text: widget.exerciseName,
          size: 18,
          weight: AppFontWeight.bold,
          color: kTextColorPrimary,
          fontFamily: AppFonts.montserrat,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(
                Icons.remove_red_eye_outlined,
                color: kTextColorPrimary,
              ),
              onPressed: () {
                Get.to(
                  () => ExerciseDetailsScreen(
                    exerciseName: widget.exerciseName,
                    mode: ExerciseDetailsMode.preview,
                  ),
                );
              },
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            height: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            child: LinearProgressIndicator(
              value: 2 / 8,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(kTertiaryColor),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Subtitle
            Center(
              child: MyText(
                text: 'Exercise Categories Selections',
                size: 12,
                weight: AppFontWeight.medium,
                color: kTextColorPrimary,
                fontFamily: AppFonts.montserrat,
              ),
            ),
            const SizedBox(height: 10.0),

            // Training Categories Selector Widget
            TrainingCategoriesSelector(
              selectedTrainings: selectedTrainings,
              selectedTechniques: selectedTechniques,
              onSelectionChanged: _onSelectionChanged,
              showSubheading: true,
            ),
            const SizedBox(height: 20.0),

            // Movement Pattern Selector Widget
            MovementPatternSelector(
              selectedPatterns: selectedMovementPatterns,
              onSelectionChanged: _onMovementPatternChanged,
              showSubheading: true,
            ),
            const SizedBox(height: 20.0),

            // Exercise Properties Toggles
            _buildExercisePropertiesSection(),
            const SizedBox(height: 30.0),

            // Action Buttons
            Column(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _onContinue(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: MyText(
                        text: 'Continue',
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
                const SizedBox(height: 50),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Build exercise properties toggles section
  Widget _buildExercisePropertiesSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          // Warm-up friendly toggle
          _buildToggleOption(
            title: 'Warm-up friendly',
            subtitle: 'This exercise can be used as general warm-up',
            value: isWarmUpFriendly,
            onChanged: (value) {
              setState(() {
                isWarmUpFriendly = value;
              });
            },
          ),
          const SizedBox(height: 20),

          // Cool-down friendly toggle
          _buildToggleOption(
            title: 'Cool-down friendly',
            subtitle: 'This exercise can be used as a cool-down',
            value: isCoolDownFriendly,
            onChanged: (value) {
              setState(() {
                isCoolDownFriendly = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // Build individual toggle option
  Widget _buildToggleOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: title,
                size: 16,
                weight: AppFontWeight.medium,
                color: kTextColorPrimary,
                fontFamily: AppFonts.montserrat,
              ),
              const SizedBox(height: 4),
              MyText(
                text: subtitle,
                size: 13,
                weight: AppFontWeight.regular,
                color: kTextColorSecondary,
                fontFamily: AppFonts.openSans,
              ),
            ],
          ),
        ),
        _CustomShadowSwitch(
          value: value,
          onChanged: onChanged,
          activeColor: kSecondaryColor,
          inactiveColor: kPrimaryColor,
          activeTrackColor: kSecondaryColor.withValues(alpha: 0.3),
          inactiveTrackColor: kSwitchInactiveColor,
        ),
      ],
    );
  }

  void _onContinue() {
    // Navigate to next screen
    Get.to(() => ExerciseWizardScreen3(exerciseName: widget.exerciseName));
  }
}

// Custom switch widget with shadow on thumb only
class _CustomShadowSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTrackColor;
  final Color inactiveTrackColor;

  const _CustomShadowSwitch({
    required this.value,
    this.onChanged,
    required this.activeColor,
    required this.inactiveColor,
    required this.activeTrackColor,
    required this.inactiveTrackColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!value) : null,
      child: Container(
        width: 51,
        height: 31,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.5),
          color: value ? activeTrackColor : inactiveTrackColor,
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 20 : 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 31,
                height: 31,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: value ? activeColor : inactiveColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
