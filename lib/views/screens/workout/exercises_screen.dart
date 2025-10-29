import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/controllers/exercise_controller.dart';
import 'package:heavek/views/screens/workout/exercise_details_screen.dart';
import 'package:heavek/views/screens/workout/exercise_wizard_screen_1.dart';
import 'package:heavek/views/widgets/custom_search_field.dart';
import 'package:heavek/views/widgets/section_header.dart';
import 'package:heavek/views/widgets/circular_card.dart';
import 'package:heavek/views/widgets/exercise_list_item.dart';
import 'package:heavek/views/widgets/favorite_card.dart';
import 'package:heavek/views/screens/nav_bar/bottom_nav_bar.dart';
import 'package:heavek/constants/app_colors.dart';

class ExercisesScreen extends StatefulWidget {
  const ExercisesScreen({super.key});

  @override
  State<ExercisesScreen> createState() => _ExercisesScreenState();
}

class _ExercisesScreenState extends State<ExercisesScreen> with TickerProviderStateMixin {
  late ExerciseController controller;
  late ScrollController _scrollController;
  late AnimationController _favoriteAnimationController;
  late AnimationController _createdByMeAnimationController;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ExerciseController());
    _scrollController = ScrollController();
    _favoriteAnimationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _createdByMeAnimationController = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Dynamic scroll thresholds based on content
    const favoritesHeaderHeight = 50.0; // SectionHeader + spacing
    const favoritesSectionContentHeight = 145.0 + 16.0; // ListView height + spacing (updated to match new height)
    const favoritesSectionHeight = favoritesHeaderHeight + favoritesSectionContentHeight;

    const createdByMeHeaderHeight = 50.0; // SectionHeader + spacing
    const createdByMeSectionContentHeight = 84.0 + 16.0; // ListView height + spacing
    const createdByMeSectionHeight = favoritesSectionHeight + createdByMeHeaderHeight + createdByMeSectionContentHeight;

    // Smoothly collapse favorites section when scrolled past its content
    if (_scrollController.offset > favoritesSectionHeight && !_favoriteAnimationController.isCompleted) {
      _favoriteAnimationController.forward();
    } else if (_scrollController.offset <= favoritesSectionHeight && _favoriteAnimationController.isCompleted) {
      _favoriteAnimationController.reverse();
    }

    // Smoothly collapse created by me section when scrolled past its content
    if (_scrollController.offset > createdByMeSectionHeight && !_createdByMeAnimationController.isCompleted) {
      _createdByMeAnimationController.forward();
    } else if (_scrollController.offset <= createdByMeSectionHeight && _createdByMeAnimationController.isCompleted) {
      _createdByMeAnimationController.reverse();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _favoriteAnimationController.dispose();
    _createdByMeAnimationController.dispose();
    super.dispose();
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
        centerTitle: true,
        titleSpacing: 0,
        title: Obx(
          () => Text(
            controller.isSelectionMode.value ? '${controller.selectedCount} selected' : 'Exercises',
            style: const TextStyle(color: kTextColorPrimary, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        leading: Obx(
          () => controller.isSelectionMode.value
              ? IconButton(
                  icon: const Icon(Icons.close, color: kTextColorPrimary),
                  onPressed: controller.clearSelection,
                )
              : const SizedBox.shrink(),
        ),
        actions: [
          Obx(
            () => controller.isSelectionMode.value
                ? Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: kTextColorPrimary),
                        onPressed: () {
                          // Delete selected exercises functionality
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Delete Selected'),
                              content: Text('Delete ${controller.selectedCount} selected exercises?'),
                              actions: [
                                TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () {
                                    controller.clearSelection();
                                    Get.back();
                                  },
                                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: kTextColorPrimary),
                        onPressed: () {
                          // Share selected exercises functionality
                          Get.dialog(
                            AlertDialog(
                              title: const Text('Feature Not Implemented'),
                              content: const Text('Sharing exercises will be available soon!'),
                              actions: [TextButton(onPressed: () => Get.back(), child: const Text('OK'))],
                            ),
                          );
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.add, color: kTextColorPrimary),
                        onPressed: () => Get.to(() => const ExerciseWizardScreen1(exerciseName: '')),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Sticky search bar and filters (transparent background)
          Container(
            padding: const EdgeInsets.only(left: 13.0, right: 13.0, top: 13.0, bottom: 5.0),
            child: Column(
              children: [
                // Search field
                CustomSearchField(
                  hintText: 'Search exercises',
                  onChanged: controller.searchExercises,
                  onSubmit: controller.searchExercises,
                ),
                const SizedBox(height: 5),
                // Filters
                Row(
                  children: [
                    IconButton(
                      icon: SvgPicture.asset(
                        Assets.filterIcon,
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(kTextColorSecondary, BlendMode.srcIn),
                      ),
                      onPressed: () {
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Feature Not Implemented'),
                            content: const Text('Advanced filters will be available soon!'),
                            actions: [TextButton(onPressed: () => Get.back(), child: const Text('OK'))],
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Obx(
                              () => _FilterChip(
                                label: 'Muscles',
                                isActive:
                                    controller.selectedMuscle.value.isNotEmpty &&
                                    controller.selectedMuscle.value != 'all',
                                onTap: () => controller.filterByMuscle('legs'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => _FilterChip(
                                label: 'Rookie',
                                isActive: controller.selectedLevel.value == 'rookie',
                                onTap: () => controller.filterByLevel('rookie'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => _FilterChip(
                                label: 'Resistance Training',
                                isActive: controller.selectedTrainingType.value == 'resistance',
                                onTap: () => controller.filterByTrainingType('resistance'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Sticky section headers (seamless)
          AnimatedBuilder(
            animation: _scrollController,
            builder: (context, child) {
              // Immediate sticky header behavior
              const stickyHeaderHeight = 40.0; // Height of each sticky header

              // Calculate section positions
              const favoritesHeaderHeight = 50.0; // SectionHeader + spacing
              const favoritesSectionContentHeight = 140.0 + 8.0; // ListView height + spacing
              const favoritesSectionEndPosition = favoritesHeaderHeight + favoritesSectionContentHeight;

              const createdByMeSectionStartPosition = favoritesSectionEndPosition;

              // Favorites header sticks immediately when scrolling starts
              final showFavoritesHeader = _scrollController.hasClients && _scrollController.offset > 0;

              // Created by me header sticks when it would reach the bottom of the favorites sticky header
              final showCreatedByMeHeader =
                  _scrollController.hasClients &&
                  _scrollController.offset > (createdByMeSectionStartPosition - stickyHeaderHeight);

              return Container(
                child: Column(
                  children: [
                    // Sticky Favorites header - appears when favorites content is scrolled past
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: showFavoritesHeader ? 40 : 0,
                      child: showFavoritesHeader
                          ? GestureDetector(
                              onTap: () {
                                // Scroll back to favorites section
                                _scrollController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Favorites',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColorPrimary,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          'Tap to expand',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.grey.shade600),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Sticky Created by me header - appears when created by me content is scrolled past
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: showCreatedByMeHeader ? 40 : 0,
                      child: showCreatedByMeHeader
                          ? GestureDetector(
                              onTap: () {
                                // Scroll to show "Created by me" section while keeping "Favorites" collapsed
                                // We need to scroll just enough to show the "Created by me" header at the top
                                const favoritesSectionEndPosition = 140.0 + 8.0;

                                _scrollController.animateTo(
                                  favoritesSectionEndPosition +
                                      5.0, // Add small buffer to ensure "Created by me" header is visible
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 8.0),
                                alignment: Alignment.centerLeft,
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 0.5)),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Created by me',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: kTextColorPrimary,
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          'Tap to expand',
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.keyboard_arrow_up, size: 16, color: Colors.grey.shade600),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              );
            },
          ),

          // Main content
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshExercises,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 13.0, right: 13.0, top: 2.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Collapsible Favorites section
                      SizeTransition(
                        sizeFactor: Tween<double>(begin: 1.0, end: 0.0).animate(_favoriteAnimationController),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Conditionally show/hide section header to avoid duplication with sticky header
                            AnimatedBuilder(
                              animation: _scrollController,
                              builder: (context, child) {
                                final showFavoritesHeader =
                                    _scrollController.hasClients && _scrollController.offset > 0;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: showFavoritesHeader ? 0 : null,
                                  child: showFavoritesHeader
                                      ? const SizedBox.shrink()
                                      : SectionHeader(title: 'Favorites', onSeeAllTap: () {}),
                                );
                              },
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 140, // Increased from 140 to accommodate text properly
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.favoriteExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise = controller.favoriteExercises[index];
                                  return FavoriteCard(
                                    imagePath: exercise['imagePath']!,
                                    title: exercise['title']!,
                                    subtitle: exercise['subtitle']!,
                                    onTap: () {
                                      // Handle favorite card tap
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),

                      // Collapsible Created by me section
                      SizeTransition(
                        sizeFactor: Tween<double>(begin: 1.0, end: 0.0).animate(_createdByMeAnimationController),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Conditionally show/hide section header to avoid duplication with sticky header
                            AnimatedBuilder(
                              animation: _scrollController,
                              builder: (context, child) {
                                const stickyHeaderHeight = 40.0;
                                const favoritesHeaderHeight = 50.0;
                                const favoritesSectionContentHeight = 140.0 + 8.0;
                                const favoritesSectionEndPosition =
                                    favoritesHeaderHeight + favoritesSectionContentHeight;
                                const createdByMeSectionStartPosition = favoritesSectionEndPosition;

                                final showCreatedByMeHeader =
                                    _scrollController.hasClients &&
                                    _scrollController.offset > (createdByMeSectionStartPosition - stickyHeaderHeight);

                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  height: showCreatedByMeHeader ? 0 : null,
                                  child: showCreatedByMeHeader
                                      ? const SizedBox.shrink()
                                      : SectionHeader(title: 'Created by me', onSeeAllTap: () {}),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 84,
                              width: double.infinity,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                itemCount: controller.createdByMeExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise = controller.createdByMeExercises[index];
                                  return Container(
                                    height: 64,
                                    width: 192,
                                    margin: const EdgeInsets.only(right: 12, top: 4, bottom: 4),
                                    child: CircularCard(
                                      imagePath: exercise['imagePath']!,
                                      title: exercise['title']!,
                                      subtitle: exercise['subtitle']!,
                                      onTap: () {},
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),

                      // All Exercises section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('All Exercises', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                          Obx(
                            () => Text(
                              '${controller.exercises.length} exercises',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Exercise list
                      Obx(() {
                        if (controller.isLoadingExercises.value) {
                          return const Center(
                            child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
                          );
                        }

                        if (controller.exercises.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  const Icon(Icons.search_off, size: 48, color: Colors.grey),
                                  const SizedBox(height: 16),
                                  Text(
                                    controller.hasActiveFilters.value
                                        ? 'No exercises match your filters'
                                        : 'No exercises found',
                                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                  if (controller.hasActiveFilters.value) ...[
                                    const SizedBox(height: 8),
                                    TextButton(
                                      onPressed: controller.clearAllFilters,
                                      child: const Text('Clear Filters'),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          children: controller.exercises
                              .map(
                                (exercise) => Padding(
                                  padding: const EdgeInsets.only(bottom: 6.0),
                                  child: Obx(
                                    () => ExerciseListItem(
                                      exercise: exercise,
                                      isSelected: controller.isExerciseSelected(exercise.id ?? ''),
                                      onTap: () => controller.toggleExerciseSelection(exercise.id ?? ''),
                                      onLongPress: () => controller.toggleExerciseSelection(exercise.id ?? ''),
                                      onImageTap: () {
                                        Get.to(
                                          () => ExerciseDetailsScreen(
                                            exerciseId: exercise.id ?? '',
                                            exerciseName: exercise.name ?? '',
                                          ),
                                        );
                                      },
                                      onSelectionChanged: () => controller.toggleExerciseSelection(exercise.id ?? ''),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      }),

                      // Selection mode buttons
                      Obx(() {
                        if (!controller.isSelectionMode.value) {
                          return const SizedBox.shrink();
                        }

                        return Column(
                          children: [
                            const SizedBox(height: 24),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.symmetric(horizontal: 0),
                              child: ElevatedButton(
                                onPressed: controller.addExercisesToNewProgram,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade800,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: Text(
                                  'Add Exercises (${controller.selectedCount}) to a new Program',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildSecondaryButton('Add Superset', controller.createSuperset),
                                _buildSecondaryButton('Add Tri-Set', controller.createTriSet),
                                _buildSecondaryButton('Add Circuit', controller.createCircuit),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => NavBar(
          pageIndex: controller.currentNavIndex.value,
          onTap: (index) {
            if (index != 1) {
              Get.offAll(() => BottomNavBar());
            }
          },
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade200,
            foregroundColor: Colors.grey.shade800,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Filter chip widget
class _FilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: kSwitchInactiveColor,
          borderRadius: BorderRadius.circular(12),
          border: isActive ? Border.all(color: kTertiaryColor) : null,
        ),
        child: Row(
          children: [
            Text(label, style: TextStyle(fontWeight: isActive ? FontWeight.w600 : FontWeight.normal)),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 18, color: isActive ? Colors.blue.shade800 : Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
