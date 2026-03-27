class AppException implements Exception {
  final String message;

  AppException(this.message);
}

class NetworkException extends AppException {
  NetworkException() : super("Lỗi mạng");
}

class ServerException extends AppException {
  ServerException() : super("Lỗi server");
}
