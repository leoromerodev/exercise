
extension EmailValidator on String {
  bool isValidEmail() {
    final RegExp regex = RegExp(
      r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b',
      caseSensitive: false,
      multiLine: false,
    );
    return regex.hasMatch(this);
  }
}

extension UsernameValidator on String {
  bool isValidUsername() {
    return length >= 3 && !RegExp(r'^\d+$').hasMatch(this);
  }
}

extension UpperCaseValidator on String {
  bool isUpperCase() {
    return contains(RegExp(r'[A-Z]'));
  }
}

extension LowerCaseValidator on String {
  bool isLowerCase() {
    return contains(RegExp(r'[a-z]'));
  }
}

extension DigitValidator on String {
  bool isContainDigit() {
    return contains(RegExp(r'[0-9]'));
  }
}

extension SpecialCharacterValidator on String {
  bool isContainSpecialCharacter() {
    return contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }
}

extension StringExtensions on String {
  bool isNumber() {
    return double.tryParse(this) != null;
  }
}

extension WeekdayName on int {
  String weekdayToName() {
    const days = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday',
    ];
    return days[this - 1];
  }
}

extension VATValidation on String {
  bool isValidGermanVAT() {
    return RegExp(r'^DE\d{9}$').hasMatch(this);
  }
}




