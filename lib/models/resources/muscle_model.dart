import '../base_model.dart';

class MuscleModel extends BaseModel {
  String? id;
  String? name;
  List<String>? bodyBackSvgPath;
  List<String>? bodyFrontSvgPath;

  MuscleModel({
    this.id,
    this.name,
    this.bodyBackSvgPath,
    this.bodyFrontSvgPath,
    super.statusCode = 200,
    super.messages = const [],
  });

  // fromMap
  factory MuscleModel.fromMap(Map<String, dynamic> map) {
    return MuscleModel(
      id: map['id'],
      name: map['name'],
      bodyBackSvgPath: map['bodyBackSvgPath'] != null ? List<String>.from(map['bodyBackSvgPath']) : null,
      bodyFrontSvgPath: map['bodyFrontSvgPath'] != null ? List<String>.from(map['bodyFrontSvgPath']) : null,
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
      'name': name,
      'bodyBackSvgPath': bodyBackSvgPath,
      'bodyFrontSvgPath': bodyFrontSvgPath,
    };
  }

  // copyWith
  MuscleModel copyWith({
    String? id,
    String? name,
    List<String>? bodyBackSvgPath,
    List<String>? bodyFrontSvgPath,
    int? statusCode,
    List<String>? messages,
  }) {
    return MuscleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      bodyBackSvgPath: bodyBackSvgPath ?? this.bodyBackSvgPath,
      bodyFrontSvgPath: bodyFrontSvgPath ?? this.bodyFrontSvgPath,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}
