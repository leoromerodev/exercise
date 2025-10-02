import '../base_model.dart';

class UserModel extends BaseModel {
  String? id;
  String? profileImage;
  String? screenName;
  String? firstName;
  String? lastName;
  DateTime? birthday;
  EmailModel? email;

  UserModel({
    this.id,
    this.profileImage,
    this.screenName,
    this.firstName,
    this.lastName,
    this.birthday,
    this.email,
    int statusCode = 200,
    List<String> messages = const [],
  }) : super(statusCode: statusCode, messages: messages);

  // fromMap
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      profileImage: map['profileImage'],
      screenName: map['screenName'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      birthday: map['birthday'] != null
          ? DateTime.tryParse(map['birthday'])
          : null,
      email: map['email'] != null ? EmailModel.fromMap(map['email']) : null,
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
      'profileImage': profileImage,
      'screenName': screenName,
      'firstName': firstName,
      'lastName': lastName,
      'birthday': birthday?.toIso8601String(),
      'email': email?.toMap(),
    };
  }

  // copyWith
  UserModel copyWith({
    String? id,
    String? profileImage,
    String? screenName,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    EmailModel? email,
    int? statusCode,
    List<String>? messages,
  }) {
    return UserModel(
      id: id ?? this.id,
      profileImage: profileImage ?? this.profileImage,
      screenName: screenName ?? this.screenName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      email: email ?? this.email,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}

class EmailModel extends BaseModel {
  final bool? allowEmailNotifications;
  final bool? emailIsVerified;
  final String? emailAddress;

  EmailModel({
    this.allowEmailNotifications,
    this.emailIsVerified,
    this.emailAddress,
    int statusCode = 200,
    List<String> messages = const [],
  }) : super(statusCode: statusCode, messages: messages);

  // fromMap
  factory EmailModel.fromMap(Map<String, dynamic> map) {
    return EmailModel(
      allowEmailNotifications: map['allowEmailNotifications'],
      emailIsVerified: map['emailIsVerified'],
      emailAddress: map['emailAddress'],
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
      'allowEmailNotifications': allowEmailNotifications,
      'emailIsVerified': emailIsVerified,
      'emailAddress': emailAddress,
    };
  }

  // copyWith
  EmailModel copyWith({
    bool? allowEmailNotifications,
    bool? emailIsVerified,
    String? emailAddress,
    int? statusCode,
    List<String>? messages,
  }) {
    return EmailModel(
      allowEmailNotifications:
          allowEmailNotifications ?? this.allowEmailNotifications,
      emailIsVerified: emailIsVerified ?? this.emailIsVerified,
      emailAddress: emailAddress ?? this.emailAddress,
      statusCode: statusCode ?? this.statusCode,
      messages: messages ?? this.messages,
    );
  }
}
