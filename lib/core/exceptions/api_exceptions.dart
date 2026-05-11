class ApiExceptions implements Exception {
  final String? message;
  final int? statusCode;
  final dynamic data;

  ApiExceptions({this.message, this.statusCode, this.data});

  @override
  String toString() {
    return 'ApiException: $message, Status Code: $statusCode, Data: $data';
  }
}

class UnauthorizedException extends ApiExceptions {
  UnauthorizedException({super.message, super.data}) : super(statusCode: 401);
}

class TimeoutException extends ApiExceptions {
  TimeoutException(String s, {super.message}) : super(statusCode: 408);
}

class BadRequestException extends ApiExceptions {
  BadRequestException({super.message, super.data}) : super(statusCode: 400);
}

class NoInternetException extends ApiExceptions {
  NoInternetException({super.message}) : super(statusCode: 503);
}

class UnknownException extends ApiExceptions {
  UnknownException({super.message, super.data}) : super(statusCode: null);
}
