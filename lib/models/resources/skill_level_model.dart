import '../base_model.dart';

class SkillLevelModel extends BaseModel {
  String? id;
  String? levelName;
  int? order;

  SkillLevelModel({this.id, this.levelName, this.order, super.statusCode = 200, super.messages = const []});

  // fromMap
  factory SkillLevelModel.fromMap(Map<String, dynamic> map) {
    return SkillLevelModel(
      id: map['id'],
      levelName: map['levelName'],
      order: map['order'],
      statusCode: map['statusCode'] ?? 200,
      messages: List<String>.from(map['messages'] ?? []),
    );
  }

  // toMap
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {...baseMap, 'id': id, 'levelName': levelName, 'order': order};
  }

  // copyWith
  SkillLevelModel copyWith({String? id, String? levelName, int? order, int? statusCode, List<String>? messages}) {
    return SkillLevelModel(
      id: id ?? this.id,
      levelName: levelName ?? this.levelName,
      order: order ?? this.order,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}
