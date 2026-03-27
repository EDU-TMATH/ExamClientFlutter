import 'package:exam_client_flutter/core/exceptions/app_exception.dart';

class UnauthorizedException extends AppException {
  UnauthorizedException() : super("Sai tài khoản hoặc mật khẩu");
}
