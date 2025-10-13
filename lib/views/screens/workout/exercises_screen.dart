import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heavek/controllers/exercise_controller.dart';
import 'package:heavek/views/screens/workout/exercise_details_screen.dart';
import 'package:heavek/views/screens/workout/exercise_wizard_screen_1.dart';
import 'package:heavek/views/widgets/custom_search_field.dart';
import 'package:heavek/views/widgets/section_header.dart';
import 'package:heavek/views/widgets/circular_card.dart';
import 'package:heavek/views/widgets/exercise_list_item.dart';
import 'package:heavek/views/screens/nav_bar/bottom_nav_bar.dart';

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ExerciseController controller = Get.put(ExerciseController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.isSelectionMode.value ? '${controller.selectedCount} selected' : 'Exercises')),
        leading: Obx(
          () => controller.isSelectionMode.value
              ? IconButton(icon: const Icon(Icons.close), onPressed: controller.clearSelection)
              : const SizedBox.shrink(),
        ),
        actions: [
          Obx(
            () => controller.isSelectionMode.value
                ? Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.select_all),
                        onPressed: controller.selectAllExercises,
                        tooltip: 'Select All',
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear_all),
                        onPressed: controller.clearSelection,
                        tooltip: 'Clear Selection',
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Obx(
                        () => controller.hasActiveFilters.value
                            ? IconButton(
                                icon: const Icon(Icons.filter_list_off),
                                onPressed: controller.clearAllFilters,
                                tooltip: 'Clear Filters',
                              )
                            : const SizedBox.shrink(),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Get.to(() => const ExerciseWizardScreen1(exerciseName: "New Exercise"));
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refreshExercises,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo de búsqueda conectado al controlador
                CustomSearchField(hintText: 'Search exercises', onChanged: controller.searchExercises),
                const SizedBox(height: 16),

                // Filtros conectados al controlador
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        // Mostrar alerta temporal como se solicita
                        Get.dialog(
                          AlertDialog(
                            title: const Text('Feature Not Implemented'),
                            content: const Text('Advanced filtering options will be available soon.'),
                            actions: [TextButton(onPressed: () => Get.back(), child: const Text('OK'))],
                          ),
                        );
                        // TODO: Reemplazar con modal de filtros avanzados
                        // log('Advanced filter modal requested');
                      },
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            // Chip de Músculos con estado reactivo
                            Obx(
                              () => _FilterChip(
                                label: 'Muscles',
                                isActive:
                                    controller.selectedMuscle.value.isNotEmpty &&
                                    controller.selectedMuscle.value != 'all',
                                onTap: () => controller.filterByMuscle('legs'), // ⚡ Conectado
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Chip de Nivel con estado reactivo
                            Obx(
                              () => _FilterChip(
                                label: 'Rookie',
                                isActive: controller.selectedLevel.value == 'rookie',
                                onTap: () => controller.filterByLevel('rookie'), // ⚡ Conectado
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Chip de Tipo con estado reactivo
                            Obx(
                              () => _FilterChip(
                                label: 'Resistance Training',
                                isActive: controller.selectedTrainingType.value == 'resistance',
                                onTap: () => controller.filterByTrainingType('resistance'), // ⚡ Conectado
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Secciones Favorites y Created by me (permanecen igual)
                SectionHeader(title: 'Favorites', onSeeAllTap: () {}),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.favoriteExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = controller.favoriteExercises[index];
                      return _FavoriteCard(
                        imagePath: exercise['imagePath']!,
                        title: exercise['title']!,
                        subtitle: exercise['subtitle']!,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                SectionHeader(title: 'Created by me', onSeeAllTap: () {}),
                const SizedBox(height: 16),
                SizedBox(
                  height: 130,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.createdByMeExercises.length,
                    itemBuilder: (context, index) {
                      final exercise = controller.createdByMeExercises[index];
                      return CircularCard(
                        imagePath: exercise['imagePath']!,
                        title: exercise['title']!,
                        subtitle: exercise['subtitle']!,
                        onTap: () {},
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // Sección All Exercises - AHORA USA EJERCICIOS FILTRADOS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('All Exercises', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    // Contador de resultados filtrados
                    Obx(
                      () => Text(
                        '${controller.filteredExercises.length} exercises',
                        style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Lista de ejercicios FILTRADOS con estado reactivo
                Obx(() {
                  if (controller.isLoadingExercises.value) {
                    return const Center(
                      child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator()),
                    );
                  }

                  if (controller.filteredExercises.isEmpty) {
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
                              TextButton(onPressed: controller.clearAllFilters, child: const Text('Clear Filters')),
                            ],
                          ],
                        ),
                      ),
                    );
                  }

                  // Renderizar ejercicios filtrados
                  return Column(
                    children: controller
                        .filteredExercises // ⚡ USA FILTRADOS
                        .map(
                          (exercise) => Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Obx(
                              () => ExerciseListItem(
                                exercise: exercise,
                                isSelected: controller.isExerciseSelected(exercise.id),
                                onTap: () => controller.toggleExerciseSelection(exercise.id),
                                onLongPress: () => controller.toggleExerciseSelection(exercise.id),
                                onImageTap: () {
                                  Get.to(
                                    () => ExerciseDetailsScreen(exerciseId: exercise.id, exerciseName: exercise.name),
                                  );
                                },
                                onSelectionChanged: () => controller.toggleExerciseSelection(exercise.id),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                }),

                // Botones de selección (reactivos)
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

// Widget _FilterChip mejorado con estado activo
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue.shade100 : Colors.grey.shade200, // ⚡ Color dinámico
          borderRadius: BorderRadius.circular(20),
          border: isActive ? Border.all(color: Colors.blue.shade300, width: 1.5) : null, // ⚡ Borde dinámico
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.blue.shade800 : Colors.grey.shade800, // ⚡ Texto dinámico
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: isActive ? Colors.blue.shade800 : Colors.grey.shade600, // ⚡ Ícono dinámico
            ),
          ],
        ),
      ),
    );
  }
}

// Widgets auxiliares (permanecen igual)
class _FavoriteCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const _FavoriteCard({required this.imagePath, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: GestureDetector(
              onTap: () {
                Get.to(
                  () => ExerciseDetailsScreen(exerciseId: "685c63a261dfaf750b38c5df", exerciseName: title),
                ); // TODO: Remove this as it is for testing
              },
              child: Image.asset(imagePath, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
