import 'package:heavek/utils/extensions.dart';

class ValidationService {
  ValidationService._privateConstructor();

  static ValidationService? _instance;

  static ValidationService get instance {
    _instance ??= ValidationService._privateConstructor();
    return _instance!;
  }

  String? emptyValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Field is required";
    }
    return null;
  }

  String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    } else if (value.isValidEmail() == false) {
      return 'Invalid email address';
    } else {
      return null;
    }
  }

  String? userNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your username';
    } else if (value.isValidUsername() == false) {
      return 'Invalid username';
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Password is required';
    }

    if (password.length < 7) {
      return 'Password must be at least 7 characters long';
    }

    final specialCharacterRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
    if (!specialCharacterRegex.hasMatch(password)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  String? validateMatchPassword(String value, String password) {
    if (value.isEmpty) {
      return 'Please enter your password again';
    } else if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the OTP';
    } else if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    return null;
  }
}




