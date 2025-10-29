import '../base_model.dart';

class MotionPlaneModel extends BaseModel {
  String? id;
  String? name;
  String? description;

  MotionPlaneModel({this.id, this.name, this.description, super.statusCode = 200, super.messages = const []});

  // fromMap
  factory MotionPlaneModel.fromMap(Map<String, dynamic> map) {
    return MotionPlaneModel(
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
  MotionPlaneModel copyWith({String? id, String? name, String? description, int? statusCode, List<String>? messages}) {
    return MotionPlaneModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}
