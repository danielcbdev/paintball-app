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