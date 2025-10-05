import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';
import 'package:heavek/views/widgets/my_text.dart';

class SkillLevelSelector extends StatefulWidget {
  final String selectedSkillLevel;
  final Function(String) onSkillLevelChanged;
  final bool showSubtitle;
  final bool isCollapsible;

  const SkillLevelSelector({
    Key? key,
    required this.selectedSkillLevel,
    required this.onSkillLevelChanged,
    this.showSubtitle = true,
    this.isCollapsible = false,
  }) : super(key: key);

  @override
  State<SkillLevelSelector> createState() => _SkillLevelSelectorState();
}

class _SkillLevelSelectorState extends State<SkillLevelSelector> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
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
          // Title row with optional arrow icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                text: 'Skill Level',
                size: 18,
                weight: AppFontWeight.semiBold,
                color: kTextColorPrimary,
                fontFamily: AppFonts.Montserrat,
              ),
              if (widget.isCollapsible)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: kTextColorPrimary,
                    size: 24,
                  ),
                ),
            ],
          ),
          if (widget.showSubtitle) ...{
            const SizedBox(height: 8),
            MyText(
              text: 'Choose the minimum skill needed for the exercise',
              size: 13,
              weight: AppFontWeight.regular,
              color: kTextColorSecondary,
            ),
          },

          // Conditionally show buttons based on collapsible state
          if (!widget.isCollapsible || isExpanded) ...[
            const SizedBox(height: 20.0),
            // Skill Level Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSkillButton('Rookie'),
                const SizedBox(width: 8),
                _buildSkillButton('Mid'),
                const SizedBox(width: 8),
                _buildSkillButton('Advanced'),
                const SizedBox(width: 8),
                _buildSkillButton('Pro'),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillButton(String level) {
    final bool isSelected = widget.selectedSkillLevel == level;

    return IntrinsicWidth(
      child: GestureDetector(
        onTap: () {
          widget.onSkillLevelChanged(level);
        },
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected ? kSecondaryColor : kPrimaryColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? kSecondaryColor : kChipBorderColor,
              width: 1.5,
            ),
          ),
          child: Center(
            child: MyText(
              text: level,
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
}
