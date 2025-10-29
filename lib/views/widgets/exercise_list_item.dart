import 'package:flutter/material.dart';
import 'package:heavek/constants/app_colors.dart';
import 'package:heavek/models/workout/exercise_model.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/views/widgets/common_image_view.dart';

class ExerciseListItem extends StatelessWidget {
  final ExerciseModel exercise;
  final bool isFavorite;
  final bool isSelected;
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress; // Añadido
  final VoidCallback? onImageTap; // Añadido
  final VoidCallback? onSelectionChanged;

  const ExerciseListItem({
    super.key,
    required this.exercise,
    this.isFavorite = false,
    this.isSelected = false,
    this.onFavoriteTap,
    this.onTap,
    this.onLongPress, // Añadido
    this.onImageTap, // Añadido
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelectionChanged ?? onTap,
      onLongPress: onLongPress, // Conectado
      child: Container(
        margin: const EdgeInsets.only(bottom: 8), // Reduced margin
        padding: const EdgeInsets.all(12), // Reduced padding
        decoration: BoxDecoration(
          color: isSelected ? kSecondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content row
            Padding(
              padding: const EdgeInsets.only(right: 32), // Add padding to avoid overlap with favorite button
              child: Row(
                children: [
                  // Imagen del ejercicio
                  GestureDetector(
                    onTap: onImageTap, // Conectado
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: exercise.media?.thumbnail != null
                          ? Image.network(
                              exercise.media!.thumbnail!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                  ),
                  const SizedBox(width: 12), // Reduced spacing
                  // Información del ejercicio
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name ?? 'Unknown Exercise',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2), // Reduced spacing
                        Text(
                          '${exercise.targetMusclesText} • ${exercise.primarySkillLevel} • ${exercise.equipmentText}',
                          style: TextStyle(
                            fontSize: 11,
                            color: isSelected ? Colors.white.withValues(alpha: 0.8) : Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 1), // Reduced spacing
                        Row(
                          children: [
                            Flexible(child: _buildChip(exercise.primarySkillLevel, Colors.blue.shade100, isSelected)),
                            const SizedBox(width: 4),
                            Flexible(child: _buildChip(exercise.equipmentText, Colors.green.shade100, isSelected)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Favorite button positioned even closer to top right corner
            Positioned(
              top: -15,
              right: -8,
              child: IconButton(
                onPressed: onFavoriteTap,
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isSelected ? Colors.white : (isFavorite ? Colors.red : Colors.grey),
                  size: 22,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
      child: CommonImageView(imagePath: Assets.imagesExerciseDetailDefault, width: 60, height: 60, fit: BoxFit.cover),
    );
  }

  Widget _buildChip(String text, Color backgroundColor, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white.withValues(alpha: 0.2) : backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : Colors.black),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
