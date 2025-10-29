import 'dart:developer';
import 'package:heavek/constants/endpoints.dart';
import 'package:heavek/models/workout/exercise_model.dart';
import 'package:heavek/services/api_service/api_service.dart';

/// OData query parameters for exercise filtering and pagination
class ExerciseQueryParams {
  final String? filter;
  final int? top;
  final String? orderBy;
  final String? skipToken;

  const ExerciseQueryParams({this.filter, this.top, this.orderBy, this.skipToken});

  /// Creates a copy with updated parameters
  ExerciseQueryParams copyWith({String? filter, int? top, String? orderBy, String? skipToken}) {
    return ExerciseQueryParams(
      filter: filter ?? this.filter,
      top: top ?? this.top,
      orderBy: orderBy ?? this.orderBy,
      skipToken: skipToken ?? this.skipToken,
    );
  }

  /// Checks if any parameters are set
  bool get hasParameters =>
      filter?.isNotEmpty == true || top != null || orderBy?.isNotEmpty == true || skipToken?.isNotEmpty == true;
}

/// OData response wrapper for exercises
class ExerciseODataResponse {
  final List<ExerciseModel> exercises;
  final int totalCount;
  final String? nextLink;
  final String? skipToken;

  ExerciseODataResponse({required this.exercises, required this.totalCount, this.nextLink, this.skipToken});

  /// Extracts skip token from nextLink URL
  String? get nextSkipToken {
    if (nextLink == null) return null;
    final uri = Uri.parse(nextLink!);
    return uri.queryParameters['\$skiptoken'];
  }
}

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

  /// Builds OData query URL with parameters
  String _buildODataUrl(String baseUrl, ExerciseQueryParams params) {
    final uri = Uri.parse(baseUrl);
    final queryParams = <String, String>{};

    if (params.filter?.isNotEmpty == true) {
      queryParams['\$filter'] = params.filter!;
    }
    if (params.top != null) {
      queryParams['\$top'] = params.top.toString();
    }
    if (params.orderBy?.isNotEmpty == true) {
      queryParams['\$orderby'] = params.orderBy!;
    }
    if (params.skipToken?.isNotEmpty == true) {
      queryParams['\$skiptoken'] = params.skipToken!;
    }

    return uri.replace(queryParameters: queryParams).toString();
  }

  /// Gets exercises from the API with full OData response
  Future<ExerciseODataResponse> getExercisesOData({ExerciseQueryParams? queryParams}) async {
    // Check if we have a valid cache

    try {
      // Build URL with OData parameters if provided
      final url = queryParams?.hasParameters == true
          ? _buildODataUrl(_exercisesEndpoint, queryParams!)
          : _exercisesEndpoint;

      log('Fetching exercises from API with URL: $url');
      final (response, statusCode) = await _apiService.get(
        url,
        false, // not basic, requires auth token
        isAuth: true,
        successCode: 200,
        showResult: true,
      );

      // OData response structure logging
      if (response != null && response['data'] != null) {
        final dataMap = response['data'] as Map<String, dynamic>;
        log('OData count: ${dataMap['@odata.count']}');
        log('OData nextLink: ${dataMap['@odata.nextLink']}');
      }

      if (response != null && statusCode == 200) {
        // Handle OData response structure
        final data = response['data'] as Map<String, dynamic>;
        final List<dynamic> jsonData = data['value'] as List<dynamic>? ?? [];

        // Parse exercises
        final exercises = jsonData.map((json) => ExerciseModel.fromMap(json)).toList();

        log('Successfully parsed ${exercises.length} exercises from API');
        log('Total available exercises: ${data['@odata.count']}');
        if (data['@odata.nextLink'] != null) {
          log('Next page available: ${data['@odata.nextLink']}');
        }

        return ExerciseODataResponse(
          exercises: exercises,
          totalCount: data['@odata.count'] ?? 0,
          nextLink: data['@odata.nextLink'],
        );
      } else {
        final mock = _getMockExercises();
        log('Failed to load exercises, status code: $statusCode. Returning mock data (${mock.length}).');
        return ExerciseODataResponse(exercises: mock, totalCount: mock.length);
      }
    } catch (e) {
      final mock = _getMockExercises();
      log('Error in getExercisesOData: $e. Returning mock data (${mock.length}).');
      return ExerciseODataResponse(exercises: mock, totalCount: mock.length);
    }
  }

  /// Get a specific exercise by ID
  Future<ExerciseModel?> getExercise(String id) async {
    try {
      log('Fetching exercise with ID: $id');
      final (response, statusCode) = await _apiService.get(
        '$_exercisesEndpoint/$id',
        false, // not basic, requires auth token
        isAuth: true,
        successCode: 200,
        showResult: true,
      );

      if (response != null && statusCode == 200) {
        final exerciseData = response['data'];
        if (exerciseData != null) {
          final exercise = ExerciseModel.fromMap(exerciseData);
          log('Exercise fetched successfully: ${exercise.name}');
          return exercise;
        }
      }

      log('Exercise not found or failed to load, status code: $statusCode');
      return null;
    } catch (e) {
      log('Error in getExercise: $e');
      return null;
    }
  }

  /// Mock data for development/testing
  List<ExerciseModel> _getMockExercises() {
    return [
      ExerciseModel(id: '1', name: 'Squats'),
      ExerciseModel(id: '2', name: 'Push-ups'),
      ExerciseModel(id: '3', name: 'Lunges'),
      ExerciseModel(id: '4', name: 'Deadlifts'),
      ExerciseModel(id: '5', name: 'Bench Press'),
      ExerciseModel(id: '6', name: 'Pull-ups'),
      ExerciseModel(id: '7', name: 'Plank'),
      ExerciseModel(id: '8', name: 'Bicep Curls'),
      ExerciseModel(id: '9', name: 'Overhead Press'),
      ExerciseModel(id: '10', name: 'Rows'),
      ExerciseModel(id: '11', name: 'Calf Raises'),
      ExerciseModel(id: '12', name: 'Leg Press'),
      ExerciseModel(id: '13', name: 'Crunches'),
      ExerciseModel(id: '14', name: 'Russian Twists'),
      ExerciseModel(id: '15', name: 'Dips'),
      ExerciseModel(id: '16', name: 'Hip Thrusts'),
      ExerciseModel(id: '17', name: 'Lateral Raises'),
      ExerciseModel(id: '18', name: 'Face Pulls'),
      ExerciseModel(id: '19', name: 'Leg Curls'),
      ExerciseModel(id: '20', name: 'Leg Extensions'),
    ];
  }
}
