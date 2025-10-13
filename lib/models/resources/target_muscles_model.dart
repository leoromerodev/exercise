import '../base_model.dart';
import 'muscle_model.dart';

class TargetMusclesModel extends BaseModel {
  List<MuscleModel>? primary;
  List<MuscleModel>? secondary;
  List<MuscleModel>? antagonist;
  List<MuscleModel>? stabilizer;

  TargetMusclesModel({
    this.primary,
    this.secondary,
    this.antagonist,
    this.stabilizer,
    super.statusCode = 200,
    super.messages = const [],
  });

  // fromMap
  factory TargetMusclesModel.fromMap(Map<String, dynamic> map) {
    return TargetMusclesModel(
      primary: map['primary'] != null
          ? List<MuscleModel>.from(map['primary'].map((x) => MuscleModel.fromMap(x)))
          : null,
      secondary: map['secondary'] != null
          ? List<MuscleModel>.from(map['secondary'].map((x) => MuscleModel.fromMap(x)))
          : null,
      antagonist: map['antagonist'] != null
          ? List<MuscleModel>.from(map['antagonist'].map((x) => MuscleModel.fromMap(x)))
          : null,
      stabilizer: map['stabilizer'] != null
          ? List<MuscleModel>.from(map['stabilizer'].map((x) => MuscleModel.fromMap(x)))
          : null,
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
      'primary': primary?.map((x) => x.toMap()).toList(),
      'secondary': secondary?.map((x) => x.toMap()).toList(),
      'antagonist': antagonist?.map((x) => x.toMap()).toList(),
      'stabilizer': stabilizer?.map((x) => x.toMap()).toList(),
    };
  }

  // copyWith
  TargetMusclesModel copyWith({
    List<MuscleModel>? primary,
    List<MuscleModel>? secondary,
    List<MuscleModel>? antagonist,
    List<MuscleModel>? stabilizer,
    int? statusCode,
    List<String>? messages,
  }) {
    return TargetMusclesModel(
      primary: primary ?? this.primary,
      secondary: secondary ?? this.secondary,
      antagonist: antagonist ?? this.antagonist,
      stabilizer: stabilizer ?? this.stabilizer,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}
