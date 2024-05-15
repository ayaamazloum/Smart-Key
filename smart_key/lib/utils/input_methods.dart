extension InputValidation on String {
  bool get isValidName{
    final nameRegExp = RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidPassword{
  final passwordRegExp = 
    RegExp(r"^.{8,}$");
    return passwordRegExp.hasMatch(this);
  }

  bool get isValidPasscode{
  final passwordRegExp = 
    RegExp(r"^[0-9A-D]{6,}$");
    return passwordRegExp.hasMatch(this);
  }
}
