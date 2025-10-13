import '../base_model.dart';

class MovementPatternModel extends BaseModel {
  String? id;
  String? name;
  String? description;

  MovementPatternModel({this.id, this.name, this.description, super.statusCode = 200, super.messages = const []});

  // fromMap
  factory MovementPatternModel.fromMap(Map<String, dynamic> map) {
    return MovementPatternModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      statusCode: map['statusCode'] ?? 200,
      messages: List<String>.from(map['messages'] ?? []),
    );
  }

  // toMap
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {...baseMap, 'id': id, 'name': name, 'description': description};
  }

  // copyWith
  MovementPatternModel copyWith({
    String? id,
    String? name,
    String? description,
    int? statusCode,
    List<String>? messages,
  }) {
    return MovementPatternModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}
