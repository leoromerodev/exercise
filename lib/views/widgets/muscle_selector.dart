import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';
import 'package:heavek/constants/muscle_roles.dart';
import 'package:heavek/views/widgets/my_text.dart';
import 'package:heavek/views/widgets/visual_muscle_selector.dart';

// Data model classes
class MuscleGroup {
  final String name;

  MuscleGroup({required this.name});
}

class MuscleCategory {
  final String id;
  final List<MuscleGroup> muscles;

  MuscleCategory({required this.id, required this.muscles});
}

class MuscleSelector extends StatefulWidget {
  final Set<String> selectedMuscles;
  final Function(Set<String>) onSelectionChanged;
  final bool showSubheading;
  final String? customTitle;
  final String? customSubheading;

  const MuscleSelector({
    Key? key,
    required this.selectedMuscles,
    required this.onSelectionChanged,
    this.showSubheading = true,
    this.customTitle,
    this.customSubheading,
  }) : super(key: key);

  @override
  State<MuscleSelector> createState() => _MuscleSelectorState();
}

class _MuscleSelectorState extends State<MuscleSelector> {
  late List<MuscleCategory> muscleCategories;
  late Map<String, String> tabNameMapping;
  String selectedCategoryTab = 'Upper Body';

  late Set<String> selectedMuscles;

  // Role selection state
  Map<String, MuscleRole> muscleRoles =
      {}; // Currently selected muscles -> role
  Map<String, MuscleRole> persistentMuscleRoles =
      {}; // All muscles that have been assigned roles (persistent)
  String? lastSelectedMuscle;
  MuscleRole?
  selectedRole; // Nullable - no role selected when no muscle is active

  // Track which muscle is selected in each tab (for single selection per tab)
  Map<String, String?> selectedMusclePerTab = {};

  @override
  void initState() {
    super.initState();
    selectedMuscles = Set.from(widget.selectedMuscles);
    _initializeMuscleData();
  }

  void _initializeMuscleData() {
    // Initialize muscle categories based on the mockup. ToDo: Fetch from API or database later
    muscleCategories = [
      MuscleCategory(
        id: 'Upper Body',
        muscles: [
          MuscleGroup(name: 'Obliques'),
          MuscleGroup(name: 'Chest'),
          MuscleGroup(name: 'Biceps'),
          MuscleGroup(name: 'Triceps'),
          MuscleGroup(name: 'Lats'),
          MuscleGroup(name: 'Traps'),
          MuscleGroup(name: 'Forearms'),
          MuscleGroup(name: 'Abs'),
          MuscleGroup(name: 'Shoulders'),
          MuscleGroup(name: 'Mid traps'),
          MuscleGroup(name: 'Lower back'),
        ],
      ),
      MuscleCategory(
        id: 'Lower Body',
        muscles: [
          MuscleGroup(name: 'Abductors'),
          MuscleGroup(name: 'Calves'),
          MuscleGroup(name: 'Glutes'),
          MuscleGroup(name: 'Hamstrings'),
          MuscleGroup(name: 'Quads'),
          MuscleGroup(name: 'Adductors'),
        ],
      ),
      MuscleCategory(
        id: 'Full Body',
        muscles: [MuscleGroup(name: 'Full body')],
      ),
    ];

    // Create tab name mapping (display name -> actual name)
    tabNameMapping = {
      'Upper Body': 'Upper Body',
      'Lower Body': 'Lower Body',
      'Full Body': 'Full Body',
    };
  }

  // Mapping between chip names and SVG muscle IDs
  Map<String, List<String>> get chipToSvgMapping => {
    // Upper Body
    'Shoulders': ['shoulders'],
    'Chest': ['chest'],
    'Biceps': ['biceps'],
    'Triceps': ['triceps'],
    'Mid traps': ['mid-traps'],
    'Lats': ['lats'],
    'Traps': ['traps'],
    'Forearms': ['forearms'],

    // Lower Body
    'Quads': ['quads'],
    'Hamstrings': ['hamstrings'],
    'Glutes': ['glutes'],
    'Calves': ['calves'],
    'Adductors': ['adductors'],
    'Abductors': ['abductors'],

    // Full Body
    'Abs': ['abs'],
    'Obliques': ['obliques'],
    'Lower back': ['lower-back'],
    'Full Body': [], // No specific SVG mapping
  };

  // Reverse mapping: SVG muscle ID -> chip name
  Map<String, String> get svgToChipMapping {
    final Map<String, String> reverse = {};
    chipToSvgMapping.forEach((chipName, svgIds) {
      for (String svgId in svgIds) {
        reverse[svgId] = chipName;
      }
    });
    return reverse;
  }

  void _notifySelectionChanged() {
    widget.onSelectionChanged(selectedMuscles);
  }

  @override
  Widget build(BuildContext context) {
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
          // Title
          MyText(
            text: widget.customTitle ?? 'Muscles',
            size: 18,
            weight: AppFontWeight.semiBold,
            color: kTextColorPrimary,
            fontFamily: AppFonts.montserrat,
          ),

          // Optional subheading
          if (widget.showSubheading) ...[
            const SizedBox(height: 5),
            MyText(
              text:
                  widget.customSubheading ??
                  'What\'s working here? Pick the muscles and their role.',
              size: 12,
              weight: AppFontWeight.regular,
              color: kTextColorSecondary,
              fontFamily: AppFonts.openSans,
            ),
          ],

          const SizedBox(height: 10),

          // Selected muscles section
          _buildSelectedMusclesSection(),

          // Category tabs with baseline
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
                children: tabNameMapping.keys.map((shortName) {
                  return _buildCategoryTab(
                    shortName,
                    selectedCategoryTab == shortName,
                  );
                }).toList(),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Tab Content Container
          _buildTabContent(),

          const SizedBox(height: 15),

          // Visual muscle selector - interactive SVG body diagram
          VisualMuscleSelector(
            selectedMuscles: _getSelectedSvgMuscles(),
            muscleRoles: _getSelectedSvgMuscleRoles(),
            onMuscleSelected: (svgMuscleId) {
              _handleSvgMuscleSelection(svgMuscleId);
            },
          ),
          const SizedBox(height: 15),

          // Role selector
          _buildRoleSelector(),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  // Build category tab
  Widget _buildCategoryTab(String text, bool isSelected) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedCategoryTab = text;
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 6,
                bottom: 8,
                left: 8,
                right: 8,
              ),
              child: MyText(
                text: text,
                size: isSelected ? 15 : 12.5,
                weight: isSelected
                    ? AppFontWeight.semiBold
                    : AppFontWeight.medium,
                color: isSelected ? kTextColorPrimary : kTextColorSecondary,
                fontFamily: AppFonts.montserrat,
              ),
            ),
            // Active indicator
            Container(
              height: 2,
              width: double.infinity,
              color: isSelected ? kTextColorPrimary : Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  // Build tab content
  Widget _buildTabContent() {
    final category = muscleCategories.firstWhere(
      (cat) => cat.id == selectedCategoryTab,
    );

    // Get the selected muscle for the current tab
    final selectedInCurrentTab = selectedMusclePerTab[selectedCategoryTab];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: category.muscles.map((muscle) {
        // Only show as selected if it's the selected muscle in THIS tab
        bool isSelected = selectedInCurrentTab == muscle.name;

        return _buildMuscleButton(
          muscle.name,
          isSelected,
          onTap: () => _selectMuscle(muscle.name),
        );
      }).toList(),
    );
  }

  // Build individual muscle button
  Widget _buildMuscleButton(
    String text,
    bool isSelected, {
    required VoidCallback onTap,
  }) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 30,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? kSecondaryColor
                : kUnselectedChipColor.withValues(alpha: 0.41),
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: kSecondaryColor, width: 1.5)
                : null,
          ),
          child: Center(
            child: MyText(
              text: text,
              size: 13,
              weight: AppFontWeight.medium,
              color: isSelected ? Colors.white : kTextColorPrimary,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // Select muscle - add to overall selection, track latest per tab
  void _selectMuscle(String muscle) {
    setState(() {
      // Get the current tab
      final currentTab = selectedCategoryTab;

      if (selectedMuscles.contains(muscle)) {
        // If muscle is already selected, show its current role in role selector
        lastSelectedMuscle = muscle;
        selectedRole = muscleRoles[muscle] ?? MuscleRole.primary;
      } else {
        // Add new muscle to overall selection with default primary role
        selectedMuscles.add(muscle);
        muscleRoles[muscle] = MuscleRole.primary;

        // Set as active muscle in role selector with primary role selected
        lastSelectedMuscle = muscle;
        selectedRole = MuscleRole.primary;
      }

      // Update which muscle is the "active" one in this tab (for UI highlighting)
      selectedMusclePerTab[currentTab] = muscle;
    });
  }

  // Convert selected chip muscles to SVG muscle IDs
  Set<String> _getSelectedSvgMuscles() {
    final Set<String> svgMuscles = {};
    for (String chipMuscle in selectedMuscles) {
      final svgIds = chipToSvgMapping[chipMuscle];
      if (svgIds != null) {
        svgMuscles.addAll(svgIds);
      }
    }
    return svgMuscles;
  }

  // Handle SVG muscle selection and convert back to chip muscle
  void _handleSvgMuscleSelection(String svgMuscleId) {
    final chipMuscle = svgToChipMapping[svgMuscleId];
    if (chipMuscle != null) {
      // Find which tab this muscle belongs to
      String? muscleTab = _findMuscleTab(chipMuscle);

      setState(() {
        // Switch to the correct tab if needed
        if (muscleTab != null && selectedCategoryTab != muscleTab) {
          selectedCategoryTab = muscleTab;
        }

        lastSelectedMuscle = chipMuscle;
        // Set default role if not already set
        if (!muscleRoles.containsKey(chipMuscle)) {
          final roleToAssign = selectedRole ?? MuscleRole.primary;
          muscleRoles[chipMuscle] = roleToAssign;
          selectedRole = roleToAssign; // Update selected role to show in UI
        }
      });
      _selectMuscle(chipMuscle);
    }
  }

  // Helper method to find which tab a muscle belongs to
  String? _findMuscleTab(String muscleName) {
    for (final category in muscleCategories) {
      for (final muscle in category.muscles) {
        if (muscle.name == muscleName) {
          return category.id;
        }
      }
    }
    return null;
  }

  // Convert muscle roles to SVG muscle roles
  Map<String, MuscleRole> _getSelectedSvgMuscleRoles() {
    final Map<String, MuscleRole> svgMuscleRoles = {};
    muscleRoles.forEach((chipMuscle, role) {
      final svgIds = chipToSvgMapping[chipMuscle];
      if (svgIds != null) {
        for (String svgId in svgIds) {
          svgMuscleRoles[svgId] = role;
        }
      }
    });
    return svgMuscleRoles;
  }

  // Build role selector UI
  Widget _buildRoleSelector() {
    // Build header text with selected muscle name if available
    String headerText = 'Role';
    if (lastSelectedMuscle != null &&
        selectedMuscles.contains(lastSelectedMuscle)) {
      headerText = '$lastSelectedMuscle Role';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(
          text: headerText,
          size: 18,
          weight: AppFontWeight.semiBold,
          color: kTextColorPrimary,
          fontFamily: AppFonts.montserrat,
        ),
        const SizedBox(height: 12),
        Row(
          children: MuscleRole.values.map((role) {
            bool isSelected = selectedRole == role;
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: _buildRoleButton(
                role.displayName,
                isSelected,
                role.color,
                () {
                  // Only allow role selection if there's a muscle selected
                  if (lastSelectedMuscle != null &&
                      selectedMuscles.contains(lastSelectedMuscle)) {
                    setState(() {
                      selectedRole = role;
                      muscleRoles[lastSelectedMuscle!] = role;
                      persistentMuscleRoles[lastSelectedMuscle!] =
                          role; // Save to persistent storage
                    });
                  }
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Build individual role button
  Widget _buildRoleButton(
    String text,
    bool isSelected,
    Color roleColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? kSecondaryColor
              : kUnselectedChipColor.withValues(alpha: 0.41),
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: kSecondaryColor, width: 1.5)
              : null,
        ),
        child: Center(
          child: MyText(
            text: text,
            size: 10,
            weight: isSelected ? AppFontWeight.semiBold : AppFontWeight.medium,
            color: isSelected ? Colors.white : kTextColorPrimary,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // Build selected muscles section with role-colored chips
  Widget _buildSelectedMusclesSection() {
    if (selectedMuscles.isEmpty) {
      return const SizedBox.shrink();
    }

    List<Widget> selectedTags = selectedMuscles
        .map((muscle) => _buildSelectedTag(muscle, () => _removeMuscle(muscle)))
        .toList();

    return Column(
      children: [
        Wrap(spacing: 8, runSpacing: 8, children: selectedTags),
        const SizedBox(height: 16),
      ],
    );
  }

  // Helper method to build selected muscle tags with role colors
  Widget _buildSelectedTag(String muscle, VoidCallback onClose) {
    // Get the role for this muscle, default to primary
    final role = muscleRoles[muscle] ?? MuscleRole.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: role.color, // Use the role's color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyText(
            text: muscle,
            size: 12,
            weight: AppFontWeight.medium,
            color: Colors.white,
            fontFamily: AppFonts.montserrat,
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // Remove muscle from selection (handles both chip and SVG interaction)
  void _removeMuscle(String muscle) {
    setState(() {
      selectedMuscles.remove(muscle);
      muscleRoles.remove(muscle);
      persistentMuscleRoles.remove(
        muscle,
      ); // Reset role - will default to Primary when selected again

      // Remove from per-tab selection tracking
      selectedMusclePerTab.removeWhere(
        (tab, selectedMuscle) => selectedMuscle == muscle,
      );

      // If this was the last selected muscle, clear the role selection
      if (lastSelectedMuscle == muscle) {
        // Find another selected muscle to be the new "last selected" or clear if none
        if (selectedMuscles.isNotEmpty) {
          lastSelectedMuscle = selectedMuscles.first;
          selectedRole = muscleRoles[lastSelectedMuscle];
        } else {
          lastSelectedMuscle = null;
          selectedRole = null;
        }
      }

      _notifySelectionChanged();
    });
  }
}
