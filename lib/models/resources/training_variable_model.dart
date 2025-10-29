import '../base_model.dart';

class TrainingVariableModel extends BaseModel {
  String? id;
  String? name;
  List<TrainingVariableTarget>? targets;
  List<TrainingVariableUnit>? units;

  TrainingVariableModel({
    this.id,
    this.name,
    this.targets,
    this.units,
    super.statusCode = 200,
    super.messages = const [],
  });

  // fromMap
  factory TrainingVariableModel.fromMap(Map<String, dynamic> map) {
    return TrainingVariableModel(
      id: map['id'],
      name: map['name'],
      targets: map['targets'] != null
          ? List<TrainingVariableTarget>.from(map['targets'].map((x) => TrainingVariableTarget.fromMap(x)))
          : null,
      units: map['units'] != null
          ? List<TrainingVariableUnit>.from(map['units'].map((x) => TrainingVariableUnit.fromMap(x)))
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
      'id': id,
      'name': name,
      'targets': targets?.map((x) => x.toMap()).toList(),
      'units': units?.map((x) => x.toMap()).toList(),
    };
  }

  // copyWith
  TrainingVariableModel copyWith({
    String? id,
    String? name,
    List<TrainingVariableTarget>? targets,
    List<TrainingVariableUnit>? units,
    int? statusCode,
    List<String>? messages,
  }) {
    return TrainingVariableModel(
      id: id ?? this.id,
      name: name ?? this.name,
      targets: targets ?? this.targets,
      units: units ?? this.units,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}

class TrainingVariableTarget {
  String? type;
  String? description;

  TrainingVariableTarget({this.type, this.description});

  factory TrainingVariableTarget.fromMap(Map<String, dynamic> map) {
    return TrainingVariableTarget(type: map['type'], description: map['description']);
  }

  Map<String, dynamic> toMap() {
    return {'type': type, 'description': description};
  }
}

class TrainingVariableUnit {
  String? value;
  String? label;
  String? description;

  TrainingVariableUnit({this.value, this.label, this.description});

  factory TrainingVariableUnit.fromMap(Map<String, dynamic> map) {
    return TrainingVariableUnit(value: map['value'], label: map['label'], description: map['description']);
  }

  Map<String, dynamic> toMap() {
    return {'value': value, 'label': label, 'description': description};
  }
}
