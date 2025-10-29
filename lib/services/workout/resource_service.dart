import 'package:heavek/constants/endpoints.dart';
import 'package:heavek/models/resources/muscle_model.dart';
import 'package:heavek/services/api_service/api_service.dart';

class ResourceService {
  // Private constructor
  ResourceService._privateConstructor();

  // Singleton instance variable
  static ResourceService? _instance;

  // Get reference to the base API service
  final APIService _apiService = APIService.instance;
  static const String _resourcesEndpoint = resourcesLink;

  // Getter to access the singleton instance
  static ResourceService get instance {
    _instance ??= ResourceService._privateConstructor();
    return _instance!;
  }

  /// Get all body muscles
  Future<List<MuscleModel>> getAllMuscles() async {
    try {
      final (response, statusCode) = await _apiService.get(
        '$_resourcesEndpoint/body-muscles',
        false, // requires auth token
        successCode: 200,
        showResult: true,
      );

      if (response != null && statusCode != null && (statusCode == 200 || statusCode == 201)) {
        // Parse the response data
        final List<dynamic> musclesData = response['data'] ?? [];
        final List<String> messages = List<String>.from(response['messages'] ?? []);

        // Convert each muscle data to MuscleModel
        return musclesData.map((muscleData) {
          return MuscleModel.fromMap({...muscleData, 'statusCode': statusCode, 'messages': messages});
        }).toList();
      }
      return [];
    } catch (e) {
      print('Error in getAllMuscles: $e');
      return [];
    }
  }
}
