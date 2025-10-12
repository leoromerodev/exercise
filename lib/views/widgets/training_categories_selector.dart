import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';
import 'package:heavek/views/widgets/my_text.dart';

// Data model classes
class Technique {
  final String name;

  Technique({required this.name});

  factory Technique.fromJson(Map<String, dynamic> json) {
    return Technique(name: json['name']);
  }
}

class Training {
  final String id;
  final String name;
  final List<Technique>? techniques;

  Training({required this.id, required this.name, this.techniques});

  factory Training.fromJson(Map<String, dynamic> json) {
    List<Technique>? techniques;
    if (json['techniques'] != null) {
      techniques = (json['techniques'] as List)
          .map((technique) => Technique.fromJson(technique))
          .toList();
    }

    return Training(
      id: json['id']['\$oid'],
      name: json['name'],
      techniques: techniques,
    );
  }
}

class TrainingCategory {
  final String id;
  final List<Training> trainings;

  TrainingCategory({required this.id, required this.trainings});

  factory TrainingCategory.fromJson(Map<String, dynamic> json) {
    return TrainingCategory(
      id: json['_id'],
      trainings: (json['trainings'] as List)
          .map((training) => Training.fromJson(training))
          .toList(),
    );
  }
}

class TrainingCategoriesSelector extends StatefulWidget {
  final Map<String, Set<String>> selectedTrainings;
  final Map<String, Set<String>> selectedTechniques;
  final Function(Map<String, Set<String>>, Map<String, Set<String>>)
  onSelectionChanged;
  final bool showSubheading;
  final String? customTitle;
  final String? customSubheading;

  const TrainingCategoriesSelector({
    Key? key,
    required this.selectedTrainings,
    required this.selectedTechniques,
    required this.onSelectionChanged,
    this.showSubheading = true,
    this.customTitle,
    this.customSubheading,
  }) : super(key: key);

  @override
  State<TrainingCategoriesSelector> createState() =>
      _TrainingCategoriesSelectorState();
}

class _TrainingCategoriesSelectorState
    extends State<TrainingCategoriesSelector> {
  late List<TrainingCategory> trainingCategories;
  late Map<String, String> tabNameMapping;
  String selectedCategoryTab = 'Foundational';

  late Map<String, Set<String>> selectedTrainings;
  late Map<String, Set<String>> selectedTechniques;

  @override
  void initState() {
    super.initState();
    selectedTrainings = Map.from(widget.selectedTrainings);
    selectedTechniques = Map.from(widget.selectedTechniques);
    _initializeTrainingData();
  }

  void _initializeTrainingData() {
    // Initialize with the provided JSON data. This json mimics the structure returned from the API
    List<Map<String, dynamic>> jsonData = [
      {
        "_id": "Foundational Training",
        "trainings": [
          {
            "id": {"\$oid": "684cb0263ca3fd31e1834962"},
            "name": "Flexibility",
            "techniques": [
              {"name": "Static Stretching"},
              {"name": "Dynamic Stretching"},
              {"name": "PNF Stretching"},
              {"name": "MSR Stretching"},
            ],
          },
          {
            "id": {"\$oid": "687eb19461dfaf750b38c623"},
            "name": "Core",
            "techniques": null,
          },
          {
            "id": {"\$oid": "687eb1e261dfaf750b38c625"},
            "name": "Balance",
            "techniques": null,
          },
        ],
      },
      {
        "_id": "Strength Training",
        "trainings": [
          {
            "id": {"\$oid": "684cb0263ca3fd31e1834963"},
            "name": "Resistance Training",
            "techniques": null,
          },
        ],
      },
      {
        "_id": "Speed, Agility, Quickness (SAQ)",
        "trainings": [
          {
            "id": {"\$oid": "684cb0263ca3fd31e1834965"},
            "name": "Reactive Training",
            "techniques": null,
          },
          {
            "id": {"\$oid": "684cb0263ca3fd31e1834966"},
            "name": "Ballistic Training",
            "techniques": null,
          },
          {
            "id": {"\$oid": "684cb0263ca3fd31e1834967"},
            "name": "Plyometric Training",
            "techniques": null,
          },
          {
            "id": {"\$oid": "684cb0263ca3fd31e1834968"},
            "name": "Agility Training",
            "techniques": null,
          },
        ],
      },
      {
        "_id": "Metabolic Training",
        "trainings": [
          {
            "id": {"\$oid": "684cb0263ca3fd31e1834964"},
            "name": "Cardiorespiratory Training",
            "techniques": null,
          },
        ],
      },
    ];

    trainingCategories = jsonData
        .map((json) => TrainingCategory.fromJson(json))
        .toList();

    // Create tab name mapping (shortened names for tabs)
    tabNameMapping = {
      'Strength': 'Strength Training',
      'Metabolic': 'Metabolic Training',
      'Foundational': 'Foundational Training',
      'SAQ': 'Speed, Agility, Quickness (SAQ)',
    };

    // Initialize selection maps if they're empty
    for (var category in trainingCategories) {
      selectedTrainings[category.id] ??= <String>{};
      for (var training in category.trainings) {
        if (training.techniques != null) {
          selectedTechniques[training.name] ??= <String>{};
        }
      }
    }
  }

  void _notifySelectionChanged() {
    widget.onSelectionChanged(selectedTrainings, selectedTechniques);
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
            text: widget.customTitle ?? 'Training Category',
            size: 18,
            weight: AppFontWeight.semiBold,
            color: kTextColorPrimary,
            fontFamily: AppFonts.Montserrat,
          ),

          // Optional subheading
          if (widget.showSubheading) ...[
            const SizedBox(height: 8),
            MyText(
              text:
                  widget.customSubheading ??
                  'Tag the Training Styles This Exercise belongs To',
              size: 13,
              weight: AppFontWeight.regular,
              color: kTextColorSecondary,
              fontFamily: AppFonts.OpenSans,
            ),
          ],

          const SizedBox(height: 16),

          // Selected tags section
          _buildSelectedTagsSection(),

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
          const SizedBox(height: 20),

          // Tab Content Container
          _buildTabContent(),
        ],
      ),
    );
  }

  // Build selected tags section
  Widget _buildSelectedTagsSection() {
    List<Widget> selectedTags = [];

    // Iterate through each category and add selected trainings
    for (var category in trainingCategories) {
      if (selectedTrainings[category.id]?.isNotEmpty == true) {
        for (String training in selectedTrainings[category.id]!) {
          // Special handling for Flexibility (parent with techniques)
          if (training == 'Flexibility') {
            if (selectedTechniques[training]?.isEmpty == true) {
              // Show Flexibility if no techniques are selected
              selectedTags.add(
                _buildSelectedTag(
                  training,
                  () => _removeSelection(category.id, training),
                ),
              );
            }
            // If techniques are selected, don't show Flexibility parent
          } else {
            selectedTags.add(
              _buildSelectedTag(
                training,
                () => _removeSelection(category.id, training),
              ),
            );
          }
        }
      }
    }

    // Add technique selections (instead of parent Flexibility Training)
    selectedTechniques.forEach((trainingName, techniques) {
      for (String technique in techniques) {
        selectedTags.add(
          _buildSelectedTag(
            technique,
            () => _removeTechnique(trainingName, technique),
          ),
        );
      }
    });

    if (selectedTags.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Wrap(spacing: 8, runSpacing: 8, children: selectedTags),
        const SizedBox(
          height: 6,
        ), // Add spacing only when there are selected chips
      ],
    );
  }

  // Remove a selection from the appropriate category
  void _removeSelection(String categoryId, String item) {
    setState(() {
      selectedTrainings[categoryId]?.remove(item);
      if (item == 'Flexibility') {
        selectedTechniques['Flexibility']?.clear();
      }
      _notifySelectionChanged();
    });
  }

  // Remove a technique and update parent state
  void _removeTechnique(String trainingName, String technique) {
    setState(() {
      selectedTechniques[trainingName]?.remove(technique);

      // If no techniques remain for this training, remove the parent training as well
      if (selectedTechniques[trainingName]?.isEmpty == true) {
        // Find the category that contains this training and remove it
        for (var category in trainingCategories) {
          if (selectedTrainings[category.id]?.contains(trainingName) == true) {
            selectedTrainings[category.id]?.remove(trainingName);
            break;
          }
        }
      }

      _notifySelectionChanged();
    });
  }

  // Helper method to build selected category tags
  Widget _buildSelectedTag(String text, [VoidCallback? onClose]) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyText(
            text: text,
            size: 12,
            weight: AppFontWeight.medium,
            color: Colors.white,
            fontFamily: AppFonts.Montserrat,
          ),
          if (onClose != null) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onClose,
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ],
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
                bottom: 4,
                left: 8,
                right: 8,
              ),
              child: MyText(
                text: text,
                size: isSelected ? 13 : 11,
                weight: isSelected
                    ? AppFontWeight.semiBold
                    : AppFontWeight.medium,
                color: isSelected ? kTextColorPrimary : kTextColorSecondary,
                fontFamily: AppFonts.Montserrat,
              ),
            ),
            // Underline indicator
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

  // Build tab-specific content based on selected tab
  Widget _buildTabContent() {
    // Find the category by mapping the short name to full name
    String fullCategoryName =
        tabNameMapping[selectedCategoryTab] ?? selectedCategoryTab;
    TrainingCategory? category = trainingCategories.firstWhere(
      (cat) => cat.id == fullCategoryName,
      orElse: () => trainingCategories.first,
    );

    return _buildCategoryContent(category);
  }

  // Build content for a specific category dynamically
  Widget _buildCategoryContent(TrainingCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Training types
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: category.trainings.map((training) {
            bool isSelected =
                selectedTrainings[category.id]?.contains(training.name) ??
                false;
            bool hasTechniques =
                training.techniques != null && training.techniques!.isNotEmpty;

            // For trainings with techniques, determine the display state
            bool showAsSelected = isSelected;
            bool showSpecialBorder = false;
            int? techniqueCount;

            if (hasTechniques && training.name == 'Flexibility') {
              int selectedTechniqueCount =
                  selectedTechniques[training.name]?.length ?? 0;
              if (selectedTechniqueCount > 0) {
                // Show special border and count when techniques are selected
                showAsSelected = false;
                showSpecialBorder = true;
                techniqueCount = selectedTechniqueCount;
              } else {
                // Show normal selected style when Flexibility is selected but no techniques
                showAsSelected = isSelected;
                showSpecialBorder = false;
              }
            }

            return _buildCategoryButton(
              training.name,
              showAsSelected,
              hasSpecialBorder: showSpecialBorder,
              count: techniqueCount,
              onTap: () {
                setState(() {
                  if (selectedTrainings[category.id]?.contains(training.name) ==
                      true) {
                    selectedTrainings[category.id]!.remove(training.name);
                    if (hasTechniques) {
                      selectedTechniques[training.name]?.clear();
                    }
                  } else {
                    selectedTrainings[category.id]!.add(training.name);
                  }
                  _notifySelectionChanged();
                });
              },
            );
          }).toList(),
        ),

        // Technique sections for trainings that have techniques
        ...category.trainings
            .where(
              (training) =>
                  training.techniques != null &&
                  training.techniques!.isNotEmpty &&
                  selectedTrainings[category.id]?.contains(training.name) ==
                      true,
            )
            .map((training) {
              return Column(
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: MyText(
                      text: 'Technique',
                      size: 16,
                      weight: AppFontWeight.semiBold,
                      color: kTextColorPrimary,
                      fontFamily: AppFonts.Montserrat,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: training.techniques!.map((technique) {
                      bool isTechniqueSelected =
                          selectedTechniques[training.name]?.contains(
                            technique.name,
                          ) ??
                          false;

                      return _buildCategoryButton(
                        technique.name,
                        isTechniqueSelected,
                        onTap: () {
                          setState(() {
                            if (selectedTechniques[training.name]?.contains(
                                  technique.name,
                                ) ==
                                true) {
                              selectedTechniques[training.name]!.remove(
                                technique.name,
                              );
                            } else {
                              selectedTechniques[training.name]!.add(
                                technique.name,
                              );
                            }
                            _notifySelectionChanged();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              );
            })
            .toList(),
      ],
    );
  }

  // Helper method to build category buttons
  Widget _buildCategoryButton(
    String text,
    bool isSelected, {
    bool hasInfo = false,
    VoidCallback? onTap,
    bool hasSpecialBorder = false,
    int? count,
  }) {
    return IntrinsicWidth(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? kSecondaryColor
                : kUnselectedChipColor.withValues(alpha: 0.41),
            borderRadius: BorderRadius.circular(12),
            border: isSelected || hasSpecialBorder
                ? Border.all(
                    color: hasSpecialBorder ? kTertiaryColor : kSecondaryColor,
                    width: 1.5,
                  )
                : null,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Count bubble (shown on left if count > 0)
                if (count != null && count > 0) ...[
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: kTertiaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: MyText(
                        text: count.toString(),
                        size: 11,
                        weight: AppFontWeight.semiBold,
                        color: Colors.white,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                MyText(
                  text: text,
                  size: 13,
                  weight: AppFontWeight.medium,
                  color: isSelected ? Colors.white : kTextColorPrimary,
                  textAlign: TextAlign.center,
                ),
                if (hasInfo) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: isSelected ? Colors.white : kHighlightColor,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
