class ApiException implements Exception {
  final message;

  ApiException([this.message]);

  String toString() {
    return "$message";
  }

  
}



class FetchDataException extends ApiException {
  FetchDataException([String? message])
      : super(message, );
}

class BadRequestException extends ApiException {
  BadRequestException([message]) : super(message);
}

class UnauthorisedException extends ApiException {
  UnauthorisedException([message]) : super(message);
}

class InvalidInputException extends ApiException {
  InvalidInputException([String? message]) : super(message);
}
