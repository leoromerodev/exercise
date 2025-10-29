import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;
  final double fontSize;
  final FontWeight fontWeight;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAllTap,
    this.fontSize = 17, // Reduced from 22px
    this.fontWeight = FontWeight.w600, // Use compile-time constant
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
        if (onSeeAllTap != null)
          TextButton(
            onPressed: onSeeAllTap,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // Reduced padding
              minimumSize: const Size(0, 0), // Remove minimum size
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce tap target
            ),
            child: Text(
              'See all',
              style: TextStyle(fontSize: 12, color: kTertiaryColor), // Reduced from 14px
            ),
          ),
      ],
    );
  }
}
