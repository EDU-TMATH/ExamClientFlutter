import 'package:dio/dio.dart';
import 'package:exam_client_flutter/features/auth/models/auth.dart';
import 'package:exam_client_flutter/features/auth/models/token.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future login(String u, String p) async {
    try {
      LoginRequest request = LoginRequest(username: u, password: p);

      final res = await dio.post('/api/auth/login/', data: request.toJson());

      return Token.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data['detail'];

        if (msg == "Invalid credentials") {
          throw "Sai tài khoản hoặc mật khẩu";
        }

        throw msg ?? "Đăng nhập thất bại";
      } else {
        throw "Không kết nối được server";
      }
    }
  }

  Future getMe() async {
    try {
      final res = await dio.get('/api/auth/me/');
      return res.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final msg = e.response?.data['detail'];
        throw msg ?? "Lấy thông tin người dùng thất bại";
      } else {
        throw "Không kết nối được server";
      }
    }
  }
}
