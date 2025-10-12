import 'dart:developer';
import 'package:heavek/constants/endpoints.dart';
import 'package:heavek/models/exercise/exercise_model.dart';
import 'package:heavek/services/api_service/api_service.dart';

class ExerciseService {
  // Private constructor
  ExerciseService._privateConstructor();

  // Singleton instance variable
  static ExerciseService? _instance;

  // Getter to access the singleton instance
  static ExerciseService get instance {
    _instance ??= ExerciseService._privateConstructor();
    return _instance!;
  }

  // Get reference to the base API service
  final APIService _apiService = APIService.instance;

  // Endpoint for exercises
  static const String _exercisesEndpoint = workoutLink;

  // Simple cache for exercises
  List<ExerciseModel>? _cachedExercises;
  DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(hours: 2);

  /// Gets exercises from the API or from cache
  Future<List<ExerciseModel>> getAllExercises() async {
    // Check if we have a valid cache
    if (_cachedExercises != null && _cacheTime != null && DateTime.now().difference(_cacheTime!) < _cacheDuration) {
      final total = _cachedExercises!.length;
      final taken = _cachedExercises!.take(20).length;
      log('Returning exercises from cache. Cached total: $total, returning: $taken');
      // Devuelve solo los primeros 20 del caché
      return _cachedExercises!.take(20).toList();
    }

    try {
      log('Fetching exercises from API...');
      final (response, statusCode) = await _apiService.get(
        _exercisesEndpoint,
        false, // not basic, requires auth token
        isAuth: true,
        successCode: 200,
        showResult: true,
      );

      if (response != null && statusCode == 200) {
        final List<dynamic> jsonData = response['data'] ?? [];

        // Parse exercises
        final exercises = jsonData.map((json) => ExerciseModel.fromJson(json)).toList();

        // Save to cache
        _cachedExercises = exercises;
        _cacheTime = DateTime.now();
        log('Exercises fetched and cached successfully. API total: ${exercises.length}. Returning first 20.');

        // Devuelve solo los primeros 20 de la respuesta de la API
        return exercises.take(20).toList();
      } else {
        final mock = _getMockExercises();
        log('Failed to load exercises, status code: $statusCode. Returning mock data (${mock.length}).');
        return mock; // Return mock data on failure
      }
    } catch (e) {
      final mock = _getMockExercises();
      log('Error in getAllExercises: $e. Returning mock data (${mock.length}).');
      // In case of any exception, return mock data
      return mock;
    }
  }

  /// Mock data for development/testing
  List<ExerciseModel> _getMockExercises() {
    return [
      ExerciseModel(
        id: '1',
        name: 'Squats',
        imageUrl: null, // Usará placeholder
        targetMuscles: ['Legs', 'Glutes', 'Core'],
        skillLevels: ['Beginner', 'Intermediate'],
        equipment: [],
      ),
      ExerciseModel(
        id: '2',
        name: 'Push-ups',
        imageUrl: null,
        targetMuscles: ['Chest', 'Arms', 'Shoulders'],
        skillLevels: ['Beginner'],
        equipment: [],
      ),
      ExerciseModel(
        id: '3',
        name: 'Lunges',
        imageUrl: null,
        targetMuscles: ['Legs', 'Glutes'],
        skillLevels: ['Intermediate'],
        equipment: ['Dumbbells'],
      ),
      ExerciseModel(
        id: '4',
        name: 'Deadlifts',
        imageUrl: null,
        targetMuscles: ['Back', 'Legs', 'Core', 'Arms'],
        skillLevels: ['Advanced'],
        equipment: ['Barbell', 'Plates'],
      ),
      ExerciseModel(
        id: '5',
        name: 'Bench Press',
        imageUrl: null,
        targetMuscles: ['Chest', 'Arms'],
        skillLevels: ['Intermediate', 'Advanced'],
        equipment: ['Barbell', 'Bench', 'Plates'],
      ),
      ExerciseModel(
        id: '6',
        name: 'Pull-ups',
        imageUrl: null,
        targetMuscles: ['Back', 'Arms'],
        skillLevels: ['Intermediate', 'Advanced'],
        equipment: ['Pull-up Bar'],
      ),
      ExerciseModel(
        id: '7',
        name: 'Plank',
        imageUrl: null,
        targetMuscles: ['Core'],
        skillLevels: ['Beginner', 'Intermediate'],
        equipment: [],
      ),
      ExerciseModel(
        id: '8',
        name: 'Bicep Curls',
        imageUrl: null,
        targetMuscles: ['Arms'],
        skillLevels: ['Beginner'],
        equipment: ['Dumbbells'],
      ),
      ExerciseModel(
        id: '9',
        name: 'Overhead Press',
        imageUrl: null,
        targetMuscles: ['Shoulders', 'Arms'],
        skillLevels: ['Intermediate'],
        equipment: ['Barbell', 'Dumbbells'],
      ),
      ExerciseModel(
        id: '10',
        name: 'Rows',
        imageUrl: null,
        targetMuscles: ['Back', 'Arms'],
        skillLevels: ['Intermediate'],
        equipment: ['Barbell', 'Dumbbells'],
      ),
      ExerciseModel(
        id: '11',
        name: 'Calf Raises',
        imageUrl: null,
        targetMuscles: ['Legs'],
        skillLevels: ['Beginner'],
        equipment: [],
      ),
      ExerciseModel(
        id: '12',
        name: 'Leg Press',
        imageUrl: null,
        targetMuscles: ['Legs', 'Glutes'],
        skillLevels: ['Intermediate'],
        equipment: ['Leg Press Machine'],
      ),
      ExerciseModel(
        id: '13',
        name: 'Crunches',
        imageUrl: null,
        targetMuscles: ['Core'],
        skillLevels: ['Beginner'],
        equipment: [],
      ),
      ExerciseModel(
        id: '14',
        name: 'Russian Twists',
        imageUrl: null,
        targetMuscles: ['Core'],
        skillLevels: ['Intermediate'],
        equipment: ['Medicine Ball'],
      ),
      ExerciseModel(
        id: '15',
        name: 'Dips',
        imageUrl: null,
        targetMuscles: ['Arms', 'Chest'],
        skillLevels: ['Intermediate'],
        equipment: ['Parallel Bars'],
      ),
      ExerciseModel(
        id: '16',
        name: 'Hip Thrusts',
        imageUrl: null,
        targetMuscles: ['Glutes', 'Legs'],
        skillLevels: ['Intermediate'],
        equipment: ['Barbell', 'Bench'],
      ),
      ExerciseModel(
        id: '17',
        name: 'Lateral Raises',
        imageUrl: null,
        targetMuscles: ['Shoulders'],
        skillLevels: ['Beginner'],
        equipment: ['Dumbbells'],
      ),
      ExerciseModel(
        id: '18',
        name: 'Face Pulls',
        imageUrl: null,
        targetMuscles: ['Shoulders', 'Back'],
        skillLevels: ['Intermediate'],
        equipment: ['Cable Machine'],
      ),
      ExerciseModel(
        id: '19',
        name: 'Leg Curls',
        imageUrl: null,
        targetMuscles: ['Legs'],
        skillLevels: ['Beginner'],
        equipment: ['Leg Curl Machine'],
      ),
      ExerciseModel(
        id: '20',
        name: 'Leg Extensions',
        imageUrl: null,
        targetMuscles: ['Legs'],
        skillLevels: ['Beginner'],
        equipment: ['Leg Extension Machine'],
      ),
    ];
  }
}
