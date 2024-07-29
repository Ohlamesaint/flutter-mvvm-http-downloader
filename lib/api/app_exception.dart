class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._prefix, this._message]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

class UnSupportImageTypeError extends AppException {
  UnSupportImageTypeError([String? message])
      : super("Invalid Type Request: ", message);
}

class BadRequestError extends AppException {
  BadRequestError([String? message]) : super("Bad Request: ", message);
}

class TransitionError extends AppException {
  TransitionError([String? message]) : super("Transition Failed: ", message);
}
