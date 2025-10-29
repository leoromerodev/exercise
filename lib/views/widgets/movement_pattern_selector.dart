import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';
import 'package:heavek/views/widgets/my_text.dart';

class MovementPatternSelector extends StatefulWidget {
  final Set<String> selectedPatterns;
  final Function(Set<String>) onSelectionChanged;
  final bool showSubheading;
  final String? customTitle;
  final String? customSubheading;

  const MovementPatternSelector({
    Key? key,
    required this.selectedPatterns,
    required this.onSelectionChanged,
    this.showSubheading = true,
    this.customTitle,
    this.customSubheading,
  }) : super(key: key);

  @override
  State<MovementPatternSelector> createState() =>
      _MovementPatternSelectorState();
}

class _MovementPatternSelectorState extends State<MovementPatternSelector> {
  late Set<String> selectedPatterns;

  // Movement patterns data based on the mockup
  final List<String> movementPatterns = [
    'Isolation',
    'Hinge',
    'Squat',
    'Lunge',
    'Push',
    'Pull',
    'Locomotion',
  ];

  @override
  void initState() {
    super.initState();
    selectedPatterns = Set.from(widget.selectedPatterns);
  }

  void _notifySelectionChanged() {
    widget.onSelectionChanged(selectedPatterns);
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
            text: widget.customTitle ?? 'Movement Pattern',
            size: 18,
            weight: AppFontWeight.semiBold,
            color: kTextColorPrimary,
            fontFamily: AppFonts.montserrat,
          ),

          // Optional subheading
          if (widget.showSubheading) ...[
            const SizedBox(height: 8),
            MyText(
              text:
                  widget.customSubheading ??
                  'Which Movement Patterns Does This Exercise Hit?',
              size: 13,
              weight: AppFontWeight.regular,
              color: kTextColorSecondary,
              fontFamily: AppFonts.openSans,
            ),
          ],

          const SizedBox(height: 20),

          // Movement patterns grid
          _buildPatternsGrid(),
        ],
      ),
    );
  }

  // Build movement patterns grid
  Widget _buildPatternsGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: movementPatterns.map((pattern) {
        bool isSelected = selectedPatterns.contains(pattern);

        return _buildPatternButton(
          pattern,
          isSelected,
          onTap: () => _togglePattern(pattern),
        );
      }).toList(),
    );
  }

  // Build individual pattern button
  Widget _buildPatternButton(
    String text,
    bool isSelected, {
    required VoidCallback onTap,
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

  // Toggle pattern selection
  void _togglePattern(String pattern) {
    setState(() {
      if (selectedPatterns.contains(pattern)) {
        selectedPatterns.remove(pattern);
      } else {
        selectedPatterns.add(pattern);
      }
      _notifySelectionChanged();
    });
  }
}
