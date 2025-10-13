import 'dart:developer';
import 'package:get/get.dart';
import 'package:heavek/models/workout/exercise_model_old.dart';
import 'package:heavek/models/workout/exercise_model.dart';
import 'package:heavek/services/workout/exercise_service.dart';
import 'package:heavek/services/workout/resource_service.dart';

enum ExerciseDetailsMode { preview, edit, create }

class ExerciseController extends GetxController {
  final RxList<ExerciseModelOld> allExercises = <ExerciseModelOld>[].obs;
  final RxList<ExerciseModelOld> filteredExercises = <ExerciseModelOld>[].obs;
  final RxBool isLoadingExercises = false.obs;
  final RxBool isLoadingExercise = false.obs;
  final Rx<ExerciseModel?> currentExercise = Rx<ExerciseModel?>(null);
  final RxSet<String> selectedExerciseIds = <String>{}.obs;
  final RxBool isSelectionMode = false.obs;
  final RxInt currentNavIndex = 1.obs;

  // Estados de filtros observables
  final RxString searchQuery = ''.obs;
  final RxString selectedMuscle = ''.obs;
  final RxString selectedLevel = ''.obs;
  final RxString selectedTrainingType = ''.obs;
  final RxBool hasActiveFilters = false.obs;

  // Datos estáticos para las secciones (actualizados a 5 elementos)
  final List<Map<String, String>> favoriteExercises = const [
    {'imagePath': 'assets/images/image_squats.png', 'title': 'Squats', 'subtitle': 'Legs'},
    {'imagePath': 'assets/images/image_push_ups.png', 'title': 'Push-ups', 'subtitle': 'Chest'},
    {'imagePath': 'assets/images/image_push_lunges.png', 'title': 'Lunges', 'subtitle': 'Legs'},
    {'imagePath': 'assets/images/exercise_det_def.png', 'title': 'Deadlifts', 'subtitle': 'Back'},
    {'imagePath': 'assets/images/exercise_det_def.png', 'title': 'Bicep Curls', 'subtitle': 'Arms'},
  ];

  final List<Map<String, String>> createdByMeExercises = const [
    {'imagePath': 'assets/images/exercise_det_def.png', 'title': 'Morning Routine', 'subtitle': 'Full Body'},
    {'imagePath': 'assets/images/exercise_det_def.png', 'title': 'Evening Routine', 'subtitle': 'Chest'},
    {'imagePath': 'assets/images/exercise_det_def.png', 'title': 'Quick Workout', 'subtitle': 'Arms'},
    {'imagePath': 'assets/images/exercise_det_def.png', 'title': 'Leg Day Prep', 'subtitle': 'Legs'},
    {'imagePath': 'assets/images/exercise_det_def.png', 'title': 'Core Crusher', 'subtitle': 'Core'},
  ];

  // Get reference to ExerciseService using the Singleton pattern
  final ExerciseService _exerciseService = ExerciseService.instance;
  final ResourceService _resourceService = ResourceService.instance;

  @override
  void onInit() {
    super.onInit();
    loadAllExercises();

    // Listener para aplicar filtros automáticamente cuando cambie cualquier criterio
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedMuscle, (_) => _applyFilters());
    ever(selectedLevel, (_) => _applyFilters());
    ever(selectedTrainingType, (_) => _applyFilters());
  }

  /// Carga todos los ejercicios desde el servicio
  Future<void> loadAllExercises() async {
    try {
      isLoadingExercises.value = true;
      final exercises = await _exerciseService.getAllExercises();
      allExercises.value = exercises;
      filteredExercises.value = exercises; // Inicialmente, todos los ejercicios
      log('Loaded ${exercises.length} exercises');

      final muscles = await _resourceService.getAllMuscles(); // TODO: Remove this as it is for testing
      log('Loaded ${muscles.length} muscles');
    } catch (e) {
      log('Error loading exercises: $e');
    } finally {
      isLoadingExercises.value = false;
    }
  }

  /// Aplica todos los filtros activos
  void _applyFilters() {
    List<ExerciseModelOld> filtered = allExercises.toList();

    // Filtro por búsqueda de texto (solo si tiene 3 o más caracteres)
    if (searchQuery.value.length >= 3) {
      filtered = filtered
          .where(
            (exercise) =>
                exercise.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
                exercise.targetMuscles.any((muscle) => muscle.toLowerCase().contains(searchQuery.value.toLowerCase())),
          )
          .toList();
    }

    // Filtro por músculo
    if (selectedMuscle.value.isNotEmpty && selectedMuscle.value != 'all') {
      filtered = filtered
          .where(
            (exercise) => exercise.targetMuscles.any(
              (muscle) => muscle.toLowerCase().contains(selectedMuscle.value.toLowerCase()),
            ),
          )
          .toList();
    }

    // Filtro por nivel
    if (selectedLevel.value.isNotEmpty && selectedLevel.value != 'all') {
      filtered = filtered
          .where(
            (exercise) =>
                exercise.skillLevels.any((level) => level.toLowerCase().contains(selectedLevel.value.toLowerCase())),
          )
          .toList();
    }

    // Filtro por tipo de entrenamiento
    if (selectedTrainingType.value.isNotEmpty && selectedTrainingType.value != 'all') {
      filtered = filtered.where((exercise) {
        if (selectedTrainingType.value.toLowerCase() == 'resistance') {
          return exercise.equipment.isNotEmpty;
        }
        return exercise.equipment.any(
          (equip) => equip.toLowerCase().contains(selectedTrainingType.value.toLowerCase()),
        );
      }).toList();
    }

    filteredExercises.value = filtered;
    _updateActiveFiltersStatus();

    log('Applied filters: ${filtered.length} exercises found');
  }

  /// Actualiza el estado de si hay filtros activos
  void _updateActiveFiltersStatus() {
    hasActiveFilters.value =
        searchQuery.value.isNotEmpty ||
        (selectedMuscle.value.isNotEmpty && selectedMuscle.value != 'all') ||
        (selectedLevel.value.isNotEmpty && selectedLevel.value != 'all') ||
        (selectedTrainingType.value.isNotEmpty && selectedTrainingType.value != 'all');
  }

  // MÉTODOS PARA FILTROS (llamados desde la UI)

  /// Busca ejercicios por texto
  void searchExercises(String query) {
    searchQuery.value = query;
    // El filtro se aplica automáticamente a través del listener `ever`
    log('Search query updated: $query');
  }

  /// Filtra ejercicios por músculo
  void filterByMuscle(String muscle) {
    if (selectedMuscle.value == muscle) {
      selectedMuscle.value = 'all'; // Toggle off
    } else {
      selectedMuscle.value = muscle;
    }
    log('Filtering by muscle: ${selectedMuscle.value}');
  }

  /// Filtra ejercicios por nivel
  void filterByLevel(String level) {
    if (selectedLevel.value == level) {
      selectedLevel.value = 'all'; // Toggle off
    } else {
      selectedLevel.value = level;
    }
    log('Filtering by level: ${selectedLevel.value}');
  }

  /// Filtra ejercicios por tipo de entrenamiento
  void filterByTrainingType(String type) {
    if (selectedTrainingType.value == type) {
      selectedTrainingType.value = 'all'; // Toggle off
    } else {
      selectedTrainingType.value = type;
    }
    log('Filtering by training type: ${selectedTrainingType.value}');
  }

  /// Limpia todos los filtros
  void clearAllFilters() {
    searchQuery.value = '';
    selectedMuscle.value = '';
    selectedLevel.value = '';
    selectedTrainingType.value = '';
    log('All filters cleared');
  }

  // MÉTODOS DE SELECCIÓN (permanecen igual)
  void toggleExerciseSelection(String exerciseId) {
    if (selectedExerciseIds.contains(exerciseId)) {
      selectedExerciseIds.remove(exerciseId);
    } else {
      selectedExerciseIds.add(exerciseId);
    }
    isSelectionMode.value = selectedExerciseIds.isNotEmpty;
    log('Selected exercises: ${selectedExerciseIds.length}');
  }

  void clearSelection() {
    selectedExerciseIds.clear();
    isSelectionMode.value = false;
    log('Selection cleared');
  }

  void selectAllExercises() {
    selectedExerciseIds.addAll(filteredExercises.map((e) => e.id));
    isSelectionMode.value = true;
    log('All filtered exercises selected: ${selectedExerciseIds.length}');
  }

  bool isExerciseSelected(String exerciseId) {
    return selectedExerciseIds.contains(exerciseId);
  }

  int get selectedCount => selectedExerciseIds.length;

  // ACCIONES DE NEGOCIO (permanecen igual)
  void addExercisesToNewProgram() {
    if (selectedExerciseIds.isEmpty) return;
    log('Adding ${selectedExerciseIds.length} exercises to new program');
    clearSelection();
  }

  void createSuperset() {
    if (selectedExerciseIds.isEmpty) return;
    log('Creating superset with ${selectedExerciseIds.length} exercises');
    clearSelection();
  }

  void createTriSet() {
    if (selectedExerciseIds.isEmpty) return;
    log('Creating tri-set with ${selectedExerciseIds.length} exercises');
    clearSelection();
  }

  void createCircuit() {
    if (selectedExerciseIds.isEmpty) return;
    log('Creating circuit with ${selectedExerciseIds.length} exercises');
    clearSelection();
  }

  // ACCIÓN PENDIENTE
  void logPendingAction(String action) {
    log('PENDING ACTION: $action');
  }

  // NAVEGACIÓN
  void handleNavigation(int index) {
    if (index != currentNavIndex.value) {
      clearSelection();
      log('Navigating to index: $index');
    }
  }

  /// Loads a specific exercise by ID
  Future<void> loadExercise(String id) async {
    try {
      isLoadingExercise.value = true;
      final exercise = await _exerciseService.getExercise(id);
      currentExercise.value = exercise;
      log('Loaded exercise: ${exercise?.name ?? 'Not found'}');
    } catch (e) {
      log('Error loading exercise: $e');
      currentExercise.value = null;
    } finally {
      isLoadingExercise.value = false;
    }
  }

  Future<void> refreshExercises() async {
    await loadAllExercises();
  }

  @override
  void onClose() {
    clearSelection();
    super.onClose();
  }
}
