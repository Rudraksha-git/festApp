class Validators {
  static bool isValidEmail(String value) {
    final v = value.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
  }

  static bool isValidPassword(String value) {
    return value.trim().length >= 6;
  }
}

