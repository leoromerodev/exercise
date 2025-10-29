import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/constants/app_fonts.dart';

class CircularCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const CircularCard({super.key, required this.imagePath, required this.title, required this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Remove fixed width and height to allow parent constraints
        margin: const EdgeInsets.only(right: 8), // Reduced margin
        padding: const EdgeInsets.all(8), // 8px padding as requested
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10), // Reduced border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06), // Much softer primary shadow
              blurRadius: 12, // More blur for softer effect
              offset: const Offset(0, 2), // Subtle downward shadow
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03), // Very light secondary shadow
              blurRadius: 6,
              offset: const Offset(0, 1), // Very subtle additional depth
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen con bordes redondeados
            ClipRRect(
              borderRadius: BorderRadius.circular(6), // Reduced border radius
              child: Image.asset(
                imagePath,
                width: 56, // Smaller image to match compact card
                height: 56, // Smaller image to match compact card
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 8), // Reduced spacing
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Prevent overflow
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12, // Further reduced font size
                      fontWeight: AppFontWeight.semiBold,
                      color: kTextColorPrimary,
                      height: 1.0, // Tighter line height
                    ),
                    maxLines: 1, // Reduced to single line
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6), // Added vertical spacing between title and subtitle
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10, // Further reduced font size

                      fontWeight: AppFontWeight.regular,
                      color: kTextColorSecondary,
                      height: 1.0, // Tighter line height
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
