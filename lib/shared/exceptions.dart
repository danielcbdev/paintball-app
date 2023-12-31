class CustomException {
  final String message;

  CustomException(this.message);

  @override
  String toString() {
    return message;
  }
}

class AuthException extends CustomException {
  AuthException(String message) : super(message);
}

class UserException extends CustomException {
  UserException(String message) : super(message);
}

class FidelityCardException extends CustomException {
  FidelityCardException(String message) : super(message);
}

class MatchesException extends CustomException {
  MatchesException(String message) : super(message);
}
