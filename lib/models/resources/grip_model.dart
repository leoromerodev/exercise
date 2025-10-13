import '../base_model.dart';

class GripModel extends BaseModel {
  String? id;
  String? name;
  String? description;
  bool? isAdvanced;

  GripModel({this.id, this.name, this.description, this.isAdvanced, super.statusCode = 200, super.messages = const []});

  // fromMap
  factory GripModel.fromMap(Map<String, dynamic> map) {
    return GripModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      isAdvanced: map['isAdvanced'],
      statusCode: map['statusCode'] ?? 200,
      messages: List<String>.from(map['messages'] ?? []),
    );
  }

  // toMap
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {...baseMap, 'id': id, 'name': name, 'description': description, 'isAdvanced': isAdvanced};
  }

  // copyWith
  GripModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isAdvanced,
    int? statusCode,
    List<String>? messages,
  }) {
    return GripModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isAdvanced: isAdvanced ?? this.isAdvanced,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}
