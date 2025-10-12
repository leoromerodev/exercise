import 'package:heavek/constants/endpoints.dart';

class ExerciseModel {
  final String id;
  final String name;
  final String? imageUrl;
  final List<String> targetMuscles;
  final List<String> skillLevels;
  final List<String> equipment;

  ExerciseModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.targetMuscles,
    required this.skillLevels,
    required this.equipment,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    // Helper para extraer una lista de nombres de una lista de mapas
    List<String> extractNames(List<dynamic>? data, String key) {
      if (data == null) return [];
      return data
          .map(
            (item) =>
                (item is Map<String, dynamic> ? item[key] as String? : null),
          )
          .where((name) => name != null)
          .cast<String>()
          .toList();
    }

    // Combina músculos primarios y secundarios
    final targetMusclesData = json['targetMuscles'] as Map<String, dynamic>?;
    final primaryMuscles = extractNames(targetMusclesData?['primary'], 'name');
    final secondaryMuscles = extractNames(
      targetMusclesData?['secondary'],
      'name',
    );
    final allMuscles = [...primaryMuscles, ...secondaryMuscles];

    // Extrae los niveles de habilidad
    final skillLevels = extractNames(json['skillLevels'], 'levelName');

    // Extrae el equipamiento
    final equipment = extractNames(json['equipment'], 'name');

    // Construye la URL de la imagen
    final gifPath = json['media']?['gifImage'] as String?;
    final String? imageUrl = gifPath != null
        ? '$baseUrl/media/gifs/$gifPath'
        : null;

    return ExerciseModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown Exercise',
      imageUrl: imageUrl,
      targetMuscles: allMuscles,
      skillLevels: skillLevels,
      equipment: equipment,
    );
  }

  // Obtener el músculo principal (el primero de la lista)
  String get primaryMuscle {
    return targetMuscles.isNotEmpty ? targetMuscles.first : 'Unknown';
  }

  // Obtener el nivel de habilidad principal
  String get primarySkillLevel {
    return skillLevels.isNotEmpty ? skillLevels.first : 'Beginner';
  }

  // Obtener texto de equipamiento
  String get equipmentText {
    if (equipment.isEmpty) return 'No Equipment';
    if (equipment.length <= 3) return equipment.join(', ');
    return '${equipment.take(3).join(', ')}...';
  }

  // Obtener texto de músculos objetivo
  String get targetMusclesText {
    if (targetMuscles.isEmpty) return 'Unknown';
    if (targetMuscles.length <= 3) return targetMuscles.join(', ');
    return '${targetMuscles.take(3).join(', ')}...';
  }
}




