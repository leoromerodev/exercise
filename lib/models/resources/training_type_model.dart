import '../base_model.dart';

class TrainingTypeModel extends BaseModel {
  String? id;
  String? name;
  String? category;
  String? description;
  List<dynamic>? techniques;

  TrainingTypeModel({
    this.id,
    this.name,
    this.category,
    this.description,
    this.techniques,
    super.statusCode = 200,
    super.messages = const [],
  });

  // fromMap
  factory TrainingTypeModel.fromMap(Map<String, dynamic> map) {
    return TrainingTypeModel(
      id: map['id'],
      name: map['name'],
      category: map['category'],
      description: map['description'],
      techniques: map['techniques'] != null ? List<dynamic>.from(map['techniques']) : null,
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
      'category': category,
      'description': description,
      'techniques': techniques,
    };
  }

  // copyWith
  TrainingTypeModel copyWith({
    String? id,
    String? name,
    String? category,
    String? description,
    List<dynamic>? techniques,
    int? statusCode,
    List<String>? messages,
  }) {
    return TrainingTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      description: description ?? this.description,
      techniques: techniques ?? this.techniques,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}
