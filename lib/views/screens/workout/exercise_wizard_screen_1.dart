import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';
import 'package:heavek/controllers/exercise_controller.dart';

import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_border_button.dart';
import 'exercise_details_screen.dart';
import 'package:heavek/views/widgets/skill_level_selector.dart';
import 'exercise_wizard_screen_2.dart';

class ExerciseWizardScreen1 extends StatefulWidget {
  final String exerciseName;

  const ExerciseWizardScreen1({Key? key, required this.exerciseName}) : super(key: key);

  @override
  State<ExerciseWizardScreen1> createState() => _ExerciseWizardScreen1State();
}

class _ExerciseWizardScreen1State extends State<ExerciseWizardScreen1> {
  String selectedSkillLevel = 'Mid';
  bool hasConfirmedRights = false;
  final TextEditingController youtubeController = TextEditingController();

  @override
  void dispose() {
    youtubeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor.withValues(alpha: 0.97), // Light grey background
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
              icon: const Icon(Icons.remove_red_eye_outlined, color: kTextColorPrimary),
              onPressed: () {
                Get.to(
                  () => ExerciseDetailsScreen(exerciseName: widget.exerciseName, mode: ExerciseDetailsMode.preview),
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
              value: 1 / 8,
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
                text: 'The Basics',
                size: 12,
                weight: AppFontWeight.medium,
                color: kTextColorPrimary,
                fontFamily: AppFonts.montserrat,
              ),
            ),
            const SizedBox(height: 10.0),

            // Demo Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: 'Demo',
                    size: 18,
                    weight: AppFontWeight.semiBold,
                    color: kTextColorPrimary,
                    fontFamily: AppFonts.montserrat,
                  ),
                  const SizedBox(height: 8),
                  MyText(
                    text: 'Share how it is done with a GIF, video, or YouTube link.',
                    size: 13,
                    weight: AppFontWeight.regular,
                    color: kTextColorSecondary,
                    fontFamily: AppFonts.openSans,
                  ),
                  const SizedBox(height: 20.0),

                  // Upload Section
                  CustomPaint(
                    painter: DashedBorderPainter(
                      color: Colors.grey[300]!,
                      strokeWidth: 2.0,
                      dashWidth: 8.0,
                      dashSpace: 4.0,
                      borderRadius: 12.0,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(40.0),
                      decoration: BoxDecoration(color: kMediaUploadBackgroundColor),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(Icons.perm_media, color: kTertiaryColor, size: 30),
                          const SizedBox(height: 16),
                          MyText(
                            text: 'Upload an image or video',
                            size: 15,
                            weight: AppFontWeight.semiBold,
                            fontFamily: AppFonts.openSans,
                            color: kTextColorPrimary,
                          ),
                          const SizedBox(height: 8),
                          MyText(
                            text: 'Supported formats: GIF, MP4, MOV',
                            size: 12,
                            weight: FontWeight.w400,
                            color: kTextInputHintColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Or divider
                  Row(
                    children: [
                      Expanded(child: _buildDashedDivider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: MyText(
                          text: 'or',
                          size: 14,
                          weight: FontWeight.w400,
                          color: Colors.black.withValues(alpha: 0.24),
                        ),
                      ),
                      Expanded(child: _buildDashedDivider()),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  // YouTube Link Input
                  TextField(
                    controller: youtubeController,
                    decoration: InputDecoration(
                      hintText: 'YouTube link',
                      hintStyle: TextStyle(color: kTextInputHintColor, fontSize: 16),
                      filled: true,
                      fillColor: kTextInputBackgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: kChipBorderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kPrimaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Checkbox for rights confirmation
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: hasConfirmedRights,
                        onChanged: (value) {
                          setState(() {
                            hasConfirmedRights = value ?? false;
                          });
                        },
                        activeColor: kSecondaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        side: BorderSide(color: hasConfirmedRights ? kSecondaryColor : kChipBorderColor, width: 1.5),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: MyText(
                            text: 'Confirm I own or have rights to use and share this media in the app',
                            size: 13,
                            weight: AppFontWeight.regular,
                            color: kTextColorSecondary,
                            fontFamily: AppFonts.openSans,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),

            // Skill Level Section
            SkillLevelSelector(
              selectedSkillLevel: selectedSkillLevel,
              onSkillLevelChanged: (level) {
                setState(() {
                  selectedSkillLevel = level;
                });
              },
              showSubtitle: true,
              isCollapsible: false,
            ),
            const SizedBox(height: 30.0),

            // Action Buttons
            Column(
              children: [
                Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _onContinue(), // Always clickable
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                      child: MyText(text: 'Continue', size: 16, weight: FontWeight.w600, color: kPrimaryColor),
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

  Widget _buildDashedDivider() {
    return Container(
      height: 1,
      child: CustomPaint(painter: DashedLinePainter(color: Colors.black.withValues(alpha: 0.24))),
    );
  }

  void _onContinue() {
    // Navigate to next screen
    Get.to(() => ExerciseWizardScreen2(exerciseName: widget.exerciseName));
  }
}

class DashedLinePainter extends CustomPainter {
  final Color color;
  final double dashWidth;
  final double dashSpace;

  DashedLinePainter({required this.color, this.dashWidth = 5.0, this.dashSpace = 3.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, size.height / 2), Offset(startX + dashWidth, size.height / 2), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final double borderRadius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 2.0,
    this.dashWidth = 8.0,
    this.dashSpace = 4.0,
    this.borderRadius = 12.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth),
          Radius.circular(borderRadius),
        ),
      );

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      double distance = 0;
      while (distance < pathMetric.length) {
        final nextDistance = distance + dashWidth;
        final segment = pathMetric.extractPath(
          distance,
          nextDistance > pathMetric.length ? pathMetric.length : nextDistance,
        );
        canvas.drawPath(segment, paint);
        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
