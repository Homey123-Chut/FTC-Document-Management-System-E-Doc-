class Validators {

  static bool isValidEmail(String email) {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }

  static bool isValidPassword(String? password) {
  if (password == null || password.length < 6) {
    return false;
  }

  final hasNumber = RegExp(r'[0-9]');
  final hasSpecialSymbol = RegExp(r'[!@#\$&*~`_+\-=\[\]{}();;:<>?,\./|\\]');

  return hasNumber.hasMatch(password) && hasSpecialSymbol.hasMatch(password);
}


  static bool verifyPassword({
    required String inputPassword,
    required String storedPassword,
  }) {
    return inputPassword == storedPassword;
  }
}

