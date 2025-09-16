class UserModel {
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
  });

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
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
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
  }) {
    return UserModel(
      id: id ?? this.id,
      profileImage: profileImage ?? this.profileImage,
      screenName: screenName ?? this.screenName,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      email: email ?? this.email,
    );
  }
}

class EmailModel {
  final bool? allowEmailNotifications;
  final bool? emailIsVerified;
  final String? emailAddress;

  EmailModel({
    this.allowEmailNotifications,
    this.emailIsVerified,
    this.emailAddress,
  });

  // fromMap
  factory EmailModel.fromMap(Map<String, dynamic> map) {
    return EmailModel(
      allowEmailNotifications: map['allowEmailNotifications'],
      emailIsVerified: map['emailIsVerified'],
      emailAddress: map['emailAddress'],
    );
  }

  // toMap
  Map<String, dynamic> toMap() {
    return {
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
  }) {
    return EmailModel(
      allowEmailNotifications:
          allowEmailNotifications ?? this.allowEmailNotifications,
      emailIsVerified: emailIsVerified ?? this.emailIsVerified,
      emailAddress: emailAddress ?? this.emailAddress,
    );
  }
}
