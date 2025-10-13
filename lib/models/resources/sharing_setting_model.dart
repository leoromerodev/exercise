import '../base_model.dart';

class SharingSettingModel extends BaseModel {
  String? id;
  String? setting;
  String? description;

  SharingSettingModel({this.id, this.setting, this.description, super.statusCode = 200, super.messages = const []});

  // fromMap
  factory SharingSettingModel.fromMap(Map<String, dynamic> map) {
    return SharingSettingModel(
      id: map['id'],
      setting: map['setting'],
      description: map['description'],
      statusCode: map['statusCode'] ?? 200,
      messages: List<String>.from(map['messages'] ?? []),
    );
  }

  // toMap
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {...baseMap, 'id': id, 'setting': setting, 'description': description};
  }

  // copyWith
  SharingSettingModel copyWith({
    String? id,
    String? setting,
    String? description,
    int? statusCode,
    List<String>? messages,
  }) {
    return SharingSettingModel(
      id: id ?? this.id,
      setting: setting ?? this.setting,
      description: description ?? this.description,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}
