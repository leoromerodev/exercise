import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAllTap;
  final double fontSize;
  final FontWeight fontWeight;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAllTap,
    this.fontSize = 22,
    this.fontWeight = FontWeight.bold,
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
            child: Text(
              'See all',
              style: TextStyle(fontSize: 14, color: Colors.blue.shade600),
            ),
          ),
      ],
    );
  }
}




