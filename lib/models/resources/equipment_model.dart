import '../base_model.dart';

class EquipmentModel extends BaseModel {
  String? id;
  String? name;
  String? createdAt;
  EquipmentMedia? media;

  EquipmentModel({this.id, this.name, this.createdAt, this.media, super.statusCode = 200, super.messages = const []});

  // fromMap
  factory EquipmentModel.fromMap(Map<String, dynamic> map) {
    return EquipmentModel(
      id: map['id'],
      name: map['name'],
      createdAt: map['createdAt'],
      media: map['media'] != null ? EquipmentMedia.fromMap(map['media']) : null,
      statusCode: map['statusCode'] ?? 200,
      messages: List<String>.from(map['messages'] ?? []),
    );
  }

  // toMap
  @override
  Map<String, dynamic> toMap() {
    final baseMap = super.toMap();
    return {...baseMap, 'id': id, 'name': name, 'createdAt': createdAt, 'media': media?.toMap()};
  }

  // copyWith
  EquipmentModel copyWith({
    String? id,
    String? name,
    String? createdAt,
    EquipmentMedia? media,
    int? statusCode,
    List<String>? messages,
  }) {
    return EquipmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      media: media ?? this.media,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}

class EquipmentMedia {
  String? image;

  EquipmentMedia({this.image});

  factory EquipmentMedia.fromMap(Map<String, dynamic> map) {
    return EquipmentMedia(image: map['image']);
  }

  Map<String, dynamic> toMap() {
    return {'image': image};
  }
}
