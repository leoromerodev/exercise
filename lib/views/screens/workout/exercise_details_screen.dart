import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/my_border_button.dart';
import 'package:heavek/views/widgets/visual_muscle_selector.dart';
import 'package:heavek/constants/muscle_roles.dart';

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

// Enum for feedback types
enum FeedbackType { love, like, dislike }

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  int selectedTabIndex = 0;
  bool isFavorited = false;
  int loveCount = 1126;
  int likeCount = 50;
  int dislikeCount = 10;
  FeedbackType? selectedFeedback; // Track which feedback is selected

  final List<String> tabTitles = [
    'Muscles',
    'Equipment',
    'Instructions',
    'Targets',
  ];

  // Mock muscle data for the exercise
  final Set<String> selectedMuscles = {'chest', 'shoulders', 'triceps'};
  final Map<String, MuscleRole> muscleRoles = {
    'chest': MuscleRole.primary,
    'shoulders': MuscleRole.secondary,
    'triceps': MuscleRole.secondary,
  };

  // Equipment data
  final List<String> equipmentList = [
    'Treadmill',
    'Ball',
    'Dumbbells',
    'Bands',
  ];

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
        padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Creator info
            Center(
              child: MyText(
                text: 'By @alex_fit',
                size: 12,
                weight: AppFontWeight.regular,
                color: kTextColorSecondary,
                fontFamily: AppFonts.OpenSans,
              ),
            ),
            const SizedBox(height: 6),

            // Exercise Image with overlay buttons
            _buildExerciseImage(),
            const SizedBox(height: 20),

            // Details Section
            _buildDetailsSection(),
            const SizedBox(height: 20),

            // Community Feedback
            _buildCommunityFeedback(),
            const SizedBox(height: 20),

            // Tabbed Content
            _buildTabbedContent(),
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

  Widget _buildExerciseImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Stack(
        children: [
          // Exercise Image
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage(
                  'assets/images/exercise_detail_placeholder.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay buttons
          Positioned(
            bottom: 8,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildOverlayButton(Icons.share_outlined, 'Share'),
                _buildOverlayButton(
                  isFavorited ? Icons.favorite : Icons.favorite_border,
                  'Favorite',
                  onTap: () => setState(() => isFavorited = !isFavorited),
                ),
                _buildOverlayButton(Icons.history, 'History'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayButton(
    IconData icon,
    String label, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            MyText(
              text: label,
              size: 12,
              weight: AppFontWeight.bold,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'Details',
          size: 18,
          weight: AppFontWeight.semiBold,
          color: kTextColorPrimary,
          fontFamily: AppFonts.Montserrat,
        ),
        const SizedBox(height: 8),

        // Warning section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.orange,
              width: 0.5,
            ), // Orange border
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(5, 5), // Bottom and right shadow
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: 'High risk warning',
                size: 12,
                weight: AppFontWeight.medium,
                color: Colors.black,
              ),
              const SizedBox(height: 4),
              MyText(
                text: 'People with heart condition should not',
                size: 12,
                weight: AppFontWeight.regular,
                color: Colors.black,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Details grid
        Row(
          children: [
            Expanded(child: _buildDetailItem('Skill Level', 'Beginner')),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDetailItem('Movement Pattern', 'Hinge, Push'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildDetailItem('Warm-up', 'Suitable')),
            const SizedBox(width: 16),
            Expanded(child: _buildDetailItem('Cool-down', 'Suitable')),
          ],
        ),
        const SizedBox(height: 16),
        _buildDetailItem('Category', 'Flexibility, balance'),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(5, 5), // Bottom and right shadow
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: label,
            size: 11,
            weight: AppFontWeight.regular,
            color: kTextColorSecondary,
          ),
          const SizedBox(height: 4),
          MyText(
            text: value,
            size: 13,
            weight: AppFontWeight.medium,
            color: kTextColorPrimary,
          ),
        ],
      ),
    );
  }

  Widget _buildCommunityFeedback() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: 'Community Feedback',
          size: 18,
          weight: AppFontWeight.semiBold,
          color: kTextColorPrimary,
          fontFamily: AppFonts.Montserrat,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildFeedbackButton(
              FeedbackType.love,
              Icons.favorite,
              Icons.favorite_border,
              'Love',
              loveCount,
              kUnselectedChipColor,
              Colors.red, // Icon color for love
            ),
            const SizedBox(width: 11),
            _buildFeedbackButton(
              FeedbackType.like,
              Icons.thumb_up,
              Icons.thumb_up_outlined,
              'Like',
              likeCount,
              kUnselectedChipColor,
              kTertiaryColor, // Icon color for like
            ),
            const SizedBox(width: 11),
            _buildFeedbackButton(
              FeedbackType.dislike,
              Icons.thumb_down,
              Icons.thumb_down_outlined,
              'Dislike',
              dislikeCount,
              kUnselectedChipColor,
              kTertiaryColor, // Icon color for dislike
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeedbackButton(
    FeedbackType feedbackType,
    IconData filledIcon,
    IconData outlineIcon,
    String label,
    int count,
    Color color,
    Color iconColor,
  ) {
    bool isSelected = selectedFeedback == feedbackType;

    return GestureDetector(
      onTap: () {
        setState(() {
          // Handle count changes based on selection
          if (selectedFeedback == feedbackType) {
            // Deselecting current feedback - decrease its count
            _decreaseCount(feedbackType);
            selectedFeedback = null;
          } else {
            // Selecting new feedback
            // First decrease the count of previously selected feedback (if any)
            if (selectedFeedback != null) {
              _decreaseCount(selectedFeedback!);
            }
            // Then increase the count of newly selected feedback
            _increaseCount(feedbackType);
            selectedFeedback = feedbackType;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.41),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.41)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              size: 16,
              color: iconColor,
            ),
            const SizedBox(width: 6),
            MyText(
              text: '$label ($count)',
              size: 12,
              weight: isSelected
                  ? AppFontWeight.semiBold
                  : AppFontWeight.medium,
              color: kTextColor,
              fontFamily: AppFonts.Montserrat,
            ),
          ],
        ),
      ),
    );
  }

  void _increaseCount(FeedbackType feedbackType) {
    switch (feedbackType) {
      case FeedbackType.love:
        loveCount++;
        break;
      case FeedbackType.like:
        likeCount++;
        break;
      case FeedbackType.dislike:
        dislikeCount++;
        break;
    }
  }

  void _decreaseCount(FeedbackType feedbackType) {
    switch (feedbackType) {
      case FeedbackType.love:
        if (loveCount > 0) loveCount--;
        break;
      case FeedbackType.like:
        if (likeCount > 0) likeCount--;
        break;
      case FeedbackType.dislike:
        if (dislikeCount > 0) dislikeCount--;
        break;
    }
  }

  Widget _buildTabbedContent() {
    return Column(
      children: [
        // Tab Headers with baseline
        Stack(
          children: [
            // Background horizontal line
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: kTextColorPrimary.withValues(alpha: 0.26),
              ),
            ),
            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: tabTitles.asMap().entries.map((entry) {
                int index = entry.key;
                String title = entry.value;
                bool isSelected = selectedTabIndex == index;

                return Flexible(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTabIndex = index),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                            top: 6,
                            bottom: 5,
                            left: 0,
                            right: 0,
                          ),
                          child: MyText(
                            text: title,
                            size: isSelected ? 13 : 11,
                            weight: isSelected
                                ? AppFontWeight.semiBold
                                : AppFontWeight.medium,
                            color: isSelected
                                ? kTextColorPrimary
                                : kTextColorSecondary,
                            fontFamily: AppFonts.Montserrat,
                          ),
                        ),
                        // Active indicator
                        Container(
                          height: 2,
                          width: double.infinity,
                          color: isSelected
                              ? kTextColorPrimary
                              : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        // Tab Content
        Container(padding: const EdgeInsets.all(20), child: _buildTabContent()),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0: // Muscles
        return _buildMusclesTab();
      case 1: // Equipment
        return _buildEquipmentTab();
      case 2: // Instructions
        return _buildInstructionsTab();
      case 3: // Training Targets
        return _buildTrainingTargetsTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMusclesTab() {
    return SizedBox(
      height: 250,
      child: VisualMuscleSelector(
        selectedMuscles: selectedMuscles,
        muscleRoles: muscleRoles,
        onMuscleSelected: null, // Read-only in details view
      ),
    );
  }

  Widget _buildEquipmentTab() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: equipmentList.length,
      itemBuilder: (context, index) {
        return _buildEquipmentItem(equipmentList[index]);
      },
    );
  }

  Widget _buildEquipmentItem(String equipmentName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _showEquipmentImagePreview(equipmentName),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/equipment_placeholder.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        MyText(
          text: equipmentName,
          size: 12,
          weight: AppFontWeight.medium,
          color: kTextColorPrimary,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showEquipmentImagePreview(String equipmentName) {
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Center(
            child: Stack(
              children: [
                // Rounded image container
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: InteractiveViewer(
                    child: Image.asset(
                      'assets/images/equipment_placeholder.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Close button (X) on top-right corner of image
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionsTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: '1. Start in a plank position with arms extended',
          size: 14,
          weight: AppFontWeight.regular,
          color: kTextColorPrimary,
        ),
        const SizedBox(height: 8),
        MyText(
          text: '2. Lower your body until chest nearly touches the floor',
          size: 14,
          weight: AppFontWeight.regular,
          color: kTextColorPrimary,
        ),
        const SizedBox(height: 8),
        MyText(
          text: '3. Push back up to starting position',
          size: 14,
          weight: AppFontWeight.regular,
          color: kTextColorPrimary,
        ),
      ],
    );
  }

  Widget _buildTrainingTargetsTab() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTargetCard(
                'Weight',
                Icons.fitness_center,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTargetCard('Reps', Icons.repeat, Colors.blue),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTargetCard('Time', Icons.access_time, Colors.blue),
            ),
            const SizedBox(width: 12),
            const Expanded(child: SizedBox()), // Empty space to maintain layout
          ],
        ),
      ],
    );
  }

  Widget _buildTargetCard(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 40,
            decoration: BoxDecoration(
              color: kTertiaryColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          MyText(
            text: title,
            size: 14,
            weight: AppFontWeight.medium,
            color: kTextColorSecondary,
          ),
        ],
      ),
    );
  }

  void _onPublishExercise() {
    // Handle publish exercise action
    // Save the exercise and navigate back
  }
}
