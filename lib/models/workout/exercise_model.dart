import 'package:heavek/models/resources/exercise_media_model.dart';
import 'package:heavek/models/resources/motion_plane_model.dart';
import 'package:heavek/models/resources/movement_pattern_model.dart';
import 'package:heavek/models/resources/grip_model.dart';
import 'package:heavek/models/resources/sharing_setting_model.dart';
import 'package:heavek/models/resources/skill_level_model.dart';
import 'package:heavek/models/resources/target_muscles_model.dart';
import 'package:heavek/models/resources/training_variable_model.dart';
import 'package:heavek/models/resources/training_type_model.dart';
import 'package:heavek/models/resources/equipment_model.dart';

import '../base_model.dart';

class ExerciseModel extends BaseModel {
  String? id;
  String? exerciseId;
  String? name;
  ExerciseMediaModel? media;
  TargetMusclesModel? targetMuscles;
  List<MovementPatternModel>? movementPatterns;
  List<dynamic>? bodyJoints;
  List<SkillLevelModel>? skillLevels;
  List<MotionPlaneModel>? motionPlanes;
  List<TrainingTypeModel>? trainingTypes;
  List<GripModel>? grips;
  List<TrainingVariableModel>? trainingVariables;
  List<EquipmentModel>? equipment;
  List<String>? instructions;
  List<dynamic>? highRiskWarnings;
  bool? coolDownSuitable;
  bool? warmUpSuitable;
  String? creatorUserId;
  SharingSettingModel? sharingSetting;
  bool? isDeleted;
  String? createdAt;
  String? updatedAt;

  ExerciseModel({
    this.id,
    this.exerciseId,
    this.name,
    this.media,
    this.targetMuscles,
    this.movementPatterns,
    this.bodyJoints,
    this.skillLevels,
    this.motionPlanes,
    this.trainingTypes,
    this.grips,
    this.trainingVariables,
    this.equipment,
    this.instructions,
    this.highRiskWarnings,
    this.coolDownSuitable,
    this.warmUpSuitable,
    this.creatorUserId,
    this.sharingSetting,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    super.statusCode = 200,
    super.messages = const [],
  });

  // fromMap
  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'],
      exerciseId: map['exerciseId'],
      name: map['name'],
      media: map['media'] != null ? ExerciseMediaModel.fromMap(map['media']) : null,
      targetMuscles: map['targetMuscles'] != null ? TargetMusclesModel.fromMap(map['targetMuscles']) : null,
      movementPatterns: map['movementPatterns'] != null
          ? List<MovementPatternModel>.from(map['movementPatterns'].map((x) => MovementPatternModel.fromMap(x)))
          : null,
      bodyJoints: map['bodyJoints'] != null ? List<dynamic>.from(map['bodyJoints']) : null,
      skillLevels: map['skillLevels'] != null
          ? List<SkillLevelModel>.from(map['skillLevels'].map((x) => SkillLevelModel.fromMap(x)))
          : null,
      motionPlanes: map['motionPlanes'] != null
          ? List<MotionPlaneModel>.from(map['motionPlanes'].map((x) => MotionPlaneModel.fromMap(x)))
          : null,
      trainingTypes: map['trainingTypes'] != null
          ? List<TrainingTypeModel>.from(map['trainingTypes'].map((x) => TrainingTypeModel.fromMap(x)))
          : null,
      grips: map['grips'] != null ? List<GripModel>.from(map['grips'].map((x) => GripModel.fromMap(x))) : null,
      trainingVariables: map['trainingVariables'] != null
          ? List<TrainingVariableModel>.from(map['trainingVariables'].map((x) => TrainingVariableModel.fromMap(x)))
          : null,
      equipment: map['equipment'] != null
          ? List<EquipmentModel>.from(map['equipment'].map((x) => EquipmentModel.fromMap(x)))
          : null,
      instructions: map['instructions'] != null ? List<String>.from(map['instructions']) : null,
      highRiskWarnings: map['highRiskWarnings'] != null ? List<dynamic>.from(map['highRiskWarnings']) : null,
      coolDownSuitable: map['coolDownSuitable'],
      warmUpSuitable: map['warmUpSuitable'],
      creatorUserId: map['creatorUserId'],
      sharingSetting: map['sharingSetting'] != null ? SharingSettingModel.fromMap(map['sharingSetting']) : null,
      isDeleted: map['isDeleted'],
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
      statusCode: map['statusCode'] ?? 200,
      messages: List<String>.from(map['messages'] ?? []),
    );
  }

  // toMap
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {
      ...baseMap,
      'id': id,
      'exerciseId': exerciseId,
      'name': name,
      'media': media?.toMap(),
      'targetMuscles': targetMuscles?.toMap(),
      'movementPatterns': movementPatterns?.map((x) => x.toMap()).toList(),
      'bodyJoints': bodyJoints,
      'skillLevels': skillLevels?.map((x) => x.toMap()).toList(),
      'motionPlanes': motionPlanes?.map((x) => x.toMap()).toList(),
      'trainingTypes': trainingTypes?.map((x) => x.toMap()).toList(),
      'grips': grips?.map((x) => x.toMap()).toList(),
      'trainingVariables': trainingVariables?.map((x) => x.toMap()).toList(),
      'equipment': equipment?.map((x) => x.toMap()).toList(),
      'instructions': instructions,
      'highRiskWarnings': highRiskWarnings,
      'coolDownSuitable': coolDownSuitable,
      'warmUpSuitable': warmUpSuitable,
      'creatorUserId': creatorUserId,
      'sharingSetting': sharingSetting?.toMap(),
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // copyWith
  ExerciseModel copyWith({
    String? id,
    String? exerciseId,
    String? name,
    ExerciseMediaModel? media,
    TargetMusclesModel? targetMuscles,
    List<MovementPatternModel>? movementPatterns,
    List<dynamic>? bodyJoints,
    List<SkillLevelModel>? skillLevels,
    List<MotionPlaneModel>? motionPlanes,
    List<TrainingTypeModel>? trainingTypes,
    List<GripModel>? grips,
    List<TrainingVariableModel>? trainingVariables,
    List<EquipmentModel>? equipment,
    List<String>? instructions,
    List<dynamic>? highRiskWarnings,
    bool? coolDownSuitable,
    bool? warmUpSuitable,
    String? creatorUserId,
    SharingSettingModel? sharingSetting,
    bool? isDeleted,
    String? createdAt,
    String? updatedAt,
    int? statusCode,
    List<String>? messages,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      name: name ?? this.name,
      media: media ?? this.media,
      targetMuscles: targetMuscles ?? this.targetMuscles,
      movementPatterns: movementPatterns ?? this.movementPatterns,
      bodyJoints: bodyJoints ?? this.bodyJoints,
      skillLevels: skillLevels ?? this.skillLevels,
      motionPlanes: motionPlanes ?? this.motionPlanes,
      trainingTypes: trainingTypes ?? this.trainingTypes,
      grips: grips ?? this.grips,
      trainingVariables: trainingVariables ?? this.trainingVariables,
      equipment: equipment ?? this.equipment,
      instructions: instructions ?? this.instructions,
      highRiskWarnings: highRiskWarnings ?? this.highRiskWarnings,
      coolDownSuitable: coolDownSuitable ?? this.coolDownSuitable,
      warmUpSuitable: warmUpSuitable ?? this.warmUpSuitable,
      creatorUserId: creatorUserId ?? this.creatorUserId,
      sharingSetting: sharingSetting ?? this.sharingSetting,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }

  // Helper methods for easy access to common data
  String get primaryMuscle {
    return targetMuscles?.primary?.isNotEmpty == true ? targetMuscles!.primary!.first.name ?? 'Unknown' : 'Unknown';
  }

  String get primarySkillLevel {
    return skillLevels?.isNotEmpty == true ? skillLevels!.first.levelName ?? 'Beginner' : 'Beginner';
  }

  String get equipmentText {
    if (equipment?.isEmpty != false) return 'No Equipment';
    final equipmentNames = equipment!.map((e) => e.name ?? '').where((name) => name.isNotEmpty).toList();
    if (equipmentNames.length <= 3) return equipmentNames.join(', ');
    return '${equipmentNames.take(3).join(', ')}...';
  }

  String get targetMusclesText {
    final allMuscles = <String>[];
    if (targetMuscles?.primary != null) {
      allMuscles.addAll(targetMuscles!.primary!.map((m) => m.name ?? '').where((name) => name.isNotEmpty));
    }
    if (targetMuscles?.secondary != null) {
      allMuscles.addAll(targetMuscles!.secondary!.map((m) => m.name ?? '').where((name) => name.isNotEmpty));
    }
    if (allMuscles.isEmpty) return 'Unknown';
    if (allMuscles.length <= 3) return allMuscles.join(', ');
    return '${allMuscles.take(3).join(', ')}...';
  }
}
