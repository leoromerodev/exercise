import 'dart:convert';
import 'package:flutter/foundation.dart';

class BaseModel {
  final int statusCode;
  final List<String> messages;

  BaseModel({
    required this.statusCode,
    required this.messages,
  });

  factory BaseModel.fromMap(Map<String, dynamic> map) {
    return BaseModel(
      statusCode: map['statusCode'] ?? 0,
      messages: List<String>.from(map['messages'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'statusCode': statusCode,
      'messages': messages,
    };
  }

  factory BaseModel.fromJson(String source) {
    return BaseModel.fromMap(json.decode(source));
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'BaseModel(statusCode: $statusCode, messages: $messages)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is BaseModel &&
      other.statusCode == statusCode &&
      listEquals(other.messages, messages);
  }

  @override
  int get hashCode => statusCode.hashCode ^ messages.hashCode;
}
