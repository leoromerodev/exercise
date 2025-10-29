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
    }

    // Check maximum length
    if (value.length > 30) {
      return 'Username must be 30 characters or less';
    }

    // Check minimum length
    if (value.length < 3) {
      return 'Username must be at least 3 characters long';
    }

    // Regular expression for valid username:
    // - Letters (a-z, A-Z)
    // - Numbers (0-9)
    // - Dots (.)
    // - Underscores (_)
    // - Cannot start or end with dot or underscore
    // - Cannot have consecutive dots or underscores
    final usernameRegex = RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9._]*[a-zA-Z0-9]$|^[a-zA-Z0-9]$');

    if (!usernameRegex.hasMatch(value)) {
      return 'Username can only contain letters, numbers, dots, and underscores';
    }

    // Check for consecutive dots or underscores
    if (value.contains(RegExp(r'[._]{2,}'))) {
      return 'Username cannot have consecutive dots or underscores';
    }

    // Check if it starts or ends with dot or underscore (for usernames longer than 1 character)
    if (value.length > 1 &&
        (value.startsWith('.') || value.startsWith('_') || value.endsWith('.') || value.endsWith('_'))) {
      return 'Username cannot start or end with dots or underscores';
    }

    return null;
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

  String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }

    // Check maximum length
    if (value.length > 50) {
      return 'Name must be 50 characters or less';
    }

    // Regular expression for valid name:
    // - Letters (a-z, A-Z, including accented characters)
    // - Spaces (but not at the beginning or end)
    // - Common suffixes like Jr., Sr., II, III, etc.
    // - Apostrophes for names like O'Connor, D'Angelo
    // - Hyphens for names like Mary-Jane, Jean-Claude
    final nameRegex = RegExp(r"^[a-zA-ZÀ-ÿĀ-žА-я]+(?:[\s\-\'\.][a-zA-ZÀ-ÿĀ-žА-я]+)*(?:\s(?:Jr|Sr|II|III|IV|V)\.?)?$");

    if (!nameRegex.hasMatch(value.trim())) {
      return 'Please enter a valid name (letters, spaces, and common suffixes only)';
    }

    // Additional check: no multiple consecutive spaces
    if (value.contains(RegExp(r'\s{2,}'))) {
      return 'Please remove extra spaces';
    }

    // Check for names that are too short (less than 2 characters)
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters long';
    }

    return null;
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters for validation
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // Check if it contains only digits (after removing formatting)
    if (digitsOnly.isEmpty) {
      return 'Please enter a valid phone number';
    }

    // E.164 International format validation (1-15 digits with + prefix)
    final e164Regex = RegExp(r'^\+[1-9]\d{1,14}$');
    if (value.startsWith('+')) {
      if (e164Regex.hasMatch(value)) {
        return null; // Valid E.164 format
      } else {
        return 'Invalid international format. Use +CountryCodeNumber (e.g., +1234567890)';
      }
    }

    // USA local format validation
    if (digitsOnly.length == 10) {
      // Valid 10-digit USA number
      return null;
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      // Valid 11-digit USA number with country code
      return null;
    } else {
      return 'USA numbers must be 10 digits or 11 digits starting with 1';
    }
  }

  String formatUsaPhoneNumber(String input) {
    // Remove all non-digit characters
    final digitsOnly = input.replaceAll(RegExp(r'[^\d]'), '');

    if (digitsOnly.isEmpty) return input;

    // Handle different USA number formats
    if (digitsOnly.length == 10) {
      // Format as (XXX) XXX-XXXX
      return '(${digitsOnly.substring(0, 3)}) ${digitsOnly.substring(3, 6)}-${digitsOnly.substring(6)}';
    } else if (digitsOnly.length == 11 && digitsOnly.startsWith('1')) {
      // Format as +1 (XXX) XXX-XXXX
      final areaCode = digitsOnly.substring(1, 4);
      final firstPart = digitsOnly.substring(4, 7);
      final lastPart = digitsOnly.substring(7);
      return '+1 ($areaCode) $firstPart-$lastPart';
    }

    return input; // Return original if doesn't match expected patterns
  }

  String? dobValidator(DateTime? selectedDate) {
    if (selectedDate == null) {
      return 'Date of birth is required';
    }

    final DateTime now = DateTime.now();
    final DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);

    if (selectedDate.isAfter(eighteenYearsAgo)) {
      return 'You must be at least 18 years old to use this app';
    }

    // Check if the date is too far in the past (more than 120 years ago)
    final DateTime maxAge = DateTime(now.year - 120, now.month, now.day);
    if (selectedDate.isBefore(maxAge)) {
      return 'Please enter a valid date of birth';
    }

    return null; // Valid date of birth
  }
}
