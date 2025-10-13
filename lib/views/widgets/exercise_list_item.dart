import 'package:flutter/material.dart';
import 'package:heavek/models/workout/exercise_model_old.dart';
import 'package:heavek/constants/app_images.dart';
import 'package:heavek/views/widgets/common_image_view.dart';

class ExerciseListItem extends StatelessWidget {
  final ExerciseModelOld exercise;
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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: Colors.blue.shade300, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen del ejercicio
            GestureDetector(
              onTap: onImageTap, // Conectado
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: exercise.imageUrl != null
                    ? Image.network(
                        exercise.imageUrl!,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
                      )
                    : _buildPlaceholder(),
              ),
            ),
            const SizedBox(width: 16),

            // Información del ejercicio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.name,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    exercise.targetMusclesText,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Flexible(child: _buildChip(exercise.primarySkillLevel, Colors.blue.shade100)),
                      const SizedBox(width: 4),
                      Flexible(child: _buildChip(exercise.equipmentText, Colors.green.shade100)),
                    ],
                  ),
                ],
              ),
            ),

            // Botón de favorito
            IconButton(
              onPressed: onFavoriteTap,
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 24,
              ),
            ),

            // Indicador de selección
            if (onSelectionChanged != null)
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(left: 8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? Colors.blue : Colors.transparent,
                  border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade400, width: 2),
                ),
                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
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
      child: CommonImageView(imagePath: Assets.imagesNoImageFound, width: 60, height: 60, fit: BoxFit.cover),
    );
  }

  Widget _buildChip(String text, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(12)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
