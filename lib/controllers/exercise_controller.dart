import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:heavek/models/workout/exercise_model.dart';
import 'package:heavek/services/workout/exercise_service.dart';

enum ExerciseDetailsMode { preview, edit, create }

class ExerciseController extends GetxController {
  final RxList<ExerciseModel> exercises = <ExerciseModel>[].obs;
  final RxBool isLoadingExercises = false.obs;
  final RxBool isLoadingExercise = false.obs;
  final Rx<ExerciseModel?> currentExercise = Rx<ExerciseModel?>(null);
  final RxSet<String> selectedExerciseIds = <String>{}.obs;
  final RxBool isSelectionMode = false.obs;
  final RxInt currentNavIndex = 1.obs;

  // Filter state observables for UI
  final RxString searchQuery = ''.obs;
  final RxString selectedMuscle = ''.obs;
  final RxString selectedLevel = ''.obs;
  final RxString selectedTrainingType = ''.obs;
  final RxBool hasActiveFilters = false.obs;

  // Search debouncing
  Timer? _searchTimer;

  // Datos estáticos para las secciones (actualizados a 5 elementos)
  final List<Map<String, String>> favoriteExercises = const [
    {'imagePath': 'assets/images/image_squats.png', 'title': 'Squats', 'subtitle': 'Legs'},
    {'imagePath': 'assets/images/image_push_ups.png', 'title': 'Push-ups', 'subtitle': 'Chest'},
    {'imagePath': 'assets/images/image_push_lunges.png', 'title': 'Lunges', 'subtitle': 'Legs'},
    {'imagePath': 'assets/images/exercise_det_def.png', 'title': 'Deadlifts', 'subtitle': 'Back'},
    {'imagePath': 'assets/images/exercise_det_def.png', 'title': 'Bicep Curls', 'subtitle': 'Arms'},
  ];

  final List<Map<String, String>> createdByMeExercises = const [
    {'imagePath': 'assets/images/exercise_detail_placeholder.png', 'title': 'Morning Routine', 'subtitle': 'Full Body'},
    {'imagePath': 'assets/images/exercise_detail_placeholder.png', 'title': 'Evening Routine', 'subtitle': 'Chest'},
    {'imagePath': 'assets/images/exercise_detail_placeholder.png', 'title': 'Quick Workout', 'subtitle': 'Arms'},
    {'imagePath': 'assets/images/exercise_detail_placeholder.png', 'title': 'Leg Day Prep', 'subtitle': 'Legs'},
    {'imagePath': 'assets/images/exercise_detail_placeholder.png', 'title': 'Core Crusher', 'subtitle': 'Core'},
  ];

  // Get reference to ExerciseService using the Singleton pattern
  final ExerciseService _exerciseService = ExerciseService.instance;

  @override
  void onInit() {
    super.onInit();
    getExercisesWithPagination(top: 20);
  }

  /// Carga todos los ejercicios desde el servicio
  Future<void> getExercises({ExerciseQueryParams? queryParams}) async {
    try {
      isLoadingExercises.value = true;
      final exerciseResponse = await _exerciseService.getExercisesOData(queryParams: queryParams);
      exercises.value = exerciseResponse.exercises;

      // final muscles = await _resourceService.getAllMuscles(); // TODO: Remove this as it is for testing
      // log('Loaded ${muscles.length} muscles');
    } catch (e) {
      log('Error loading exercises: $e');
    } finally {
      isLoadingExercises.value = false;
    }
  }

  /// Convenience method to get exercises with OData filter
  Future<void> getExercisesWithFilter(String filter) async {
    final queryParams = ExerciseQueryParams(filter: filter);
    await getExercises(queryParams: queryParams);
  }

  /// Convenience method to get exercises with pagination
  Future<void> getExercisesWithPagination({int? top, String? skipToken}) async {
    final queryParams = ExerciseQueryParams(top: top, skipToken: skipToken);
    await getExercises(queryParams: queryParams);
  }

  /// Convenience method to get exercises with ordering
  Future<void> getExercisesWithOrder(String orderBy) async {
    final queryParams = ExerciseQueryParams(orderBy: orderBy);
    await getExercises(queryParams: queryParams);
  }

  /// Search exercises using server-side filtering with debouncing
  void searchExercises(String query) {
    searchQuery.value = query;
    _updateActiveFiltersStatus();

    // Cancel previous timer
    _searchTimer?.cancel();

    // Set new timer for debouncing (500ms delay)
    _searchTimer = Timer(const Duration(milliseconds: 500), () async {
      await _performSearch(query);
    });
  }

  /// Internal method to perform the actual search
  Future<void> _performSearch(String query) async {
    // Build OData filter for server-side search
    String? filter;
    if (query.isNotEmpty && query.length >= 3) {
      // Minimum 3 characters required before triggering API call
      final lowerQuery = query.toLowerCase();
      // Search in multiple fields: name, target muscles, and instructions
      filter = "name contains '$lowerQuery'";
    }

    final queryParams = ExerciseQueryParams(filter: filter);
    await getExercises(queryParams: queryParams);
    log('Search query executed: $query');
  }

  /// Filter exercises by muscle using server-side filtering
  Future<void> filterByMuscle(String muscle) async {
    if (selectedMuscle.value == muscle) {
      selectedMuscle.value = 'all'; // Toggle off
    } else {
      selectedMuscle.value = muscle;
    }
    _updateActiveFiltersStatus();

    // Build OData filter for server-side muscle filtering
    String? filter;
    if (selectedMuscle.value.isNotEmpty && selectedMuscle.value != 'all') {
      filter = "contains(tolower(targetMuscles/primary/name),'${selectedMuscle.value.toLowerCase()}')";
    }

    final queryParams = ExerciseQueryParams(filter: filter);
    await getExercises(queryParams: queryParams);
    log('Filtering by muscle: ${selectedMuscle.value}');
  }

  /// Filter exercises by level using server-side filtering
  Future<void> filterByLevel(String level) async {
    if (selectedLevel.value == level) {
      selectedLevel.value = 'all'; // Toggle off
    } else {
      selectedLevel.value = level;
    }
    _updateActiveFiltersStatus();

    // Build OData filter for server-side level filtering
    String? filter;
    if (selectedLevel.value.isNotEmpty && selectedLevel.value != 'all') {
      filter = "contains(tolower(skillLevels/levelName),'${selectedLevel.value.toLowerCase()}')";
    }

    final queryParams = ExerciseQueryParams(filter: filter);
    await getExercises(queryParams: queryParams);
    log('Filtering by level: ${selectedLevel.value}');
  }

  /// Filter exercises by training type using server-side filtering
  Future<void> filterByTrainingType(String type) async {
    if (selectedTrainingType.value == type) {
      selectedTrainingType.value = 'all'; // Toggle off
    } else {
      selectedTrainingType.value = type;
    }
    _updateActiveFiltersStatus();

    // Build OData filter for server-side training type filtering
    String? filter;
    if (selectedTrainingType.value.isNotEmpty && selectedTrainingType.value != 'all') {
      if (selectedTrainingType.value.toLowerCase() == 'resistance') {
        filter = "equipment ne null";
      } else {
        filter = "contains(tolower(trainingTypes/name),'${selectedTrainingType.value.toLowerCase()}')";
      }
    }

    final queryParams = ExerciseQueryParams(filter: filter);
    await getExercises(queryParams: queryParams);
    log('Filtering by training type: ${selectedTrainingType.value}');
  }

  /// Clear all filters and reload exercises
  Future<void> clearAllFilters() async {
    searchQuery.value = '';
    selectedMuscle.value = '';
    selectedLevel.value = '';
    selectedTrainingType.value = '';
    _updateActiveFiltersStatus();

    // Reload without filters
    await getExercises();
    log('All filters cleared');
  }

  /// Update the active filters status
  void _updateActiveFiltersStatus() {
    hasActiveFilters.value =
        searchQuery.value.isNotEmpty ||
        (selectedMuscle.value.isNotEmpty && selectedMuscle.value != 'all') ||
        (selectedLevel.value.isNotEmpty && selectedLevel.value != 'all') ||
        (selectedTrainingType.value.isNotEmpty && selectedTrainingType.value != 'all');
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
    selectedExerciseIds.addAll(exercises.map((e) => e.id ?? '').where((id) => id.isNotEmpty));
    isSelectionMode.value = true;
    log('All exercises selected: ${selectedExerciseIds.length}');
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
  Future<void> getExercise(String id) async {
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
    await getExercises();
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    clearSelection();
    super.onClose();
  }
}
