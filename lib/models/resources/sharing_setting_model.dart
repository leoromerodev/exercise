class SharingSettingModel {
  String? id;
  String? setting;
  String? description;

  SharingSettingModel({this.id, this.setting, this.description});

  // fromMap
  factory SharingSettingModel.fromMap(Map<String, dynamic> map) {
    return SharingSettingModel(id: map['id'], setting: map['setting'], description: map['description']);
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {'id': id, 'setting': setting, 'description': description};
  }

  // copyWith
  SharingSettingModel copyWith({String? id, String? setting, String? description}) {
    return SharingSettingModel(
      id: id ?? this.id,
      setting: setting ?? this.setting,
      description: description ?? this.description,
    );
  }
}
