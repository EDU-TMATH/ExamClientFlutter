import 'package:dio/dio.dart';
import 'package:exam_client_flutter/features/auth/models/token.dart';
import 'package:exam_client_flutter/features/auth/models/user.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<User> me() async {
    final res = await dio.get('/api/auth/me');
    return User.fromJson(res.data);
  }

  Future<Token> refresh(String refreshToken) async {
    final res = await dio.post(
      '/api/auth/refresh',
      data: {'refresh': refreshToken},
    );
    return Token.fromJson(res.data);
  }

  Future<Token> login(String username, String password) async {
    final res = await dio.post(
      '/api/auth/login',
      data: {'username': username, 'password': password},
    );

    return Token.fromJson(res.data);
  }

  Future<void> logout(String refreshToken) async {
    await dio.post('/api/auth/logout', data: {'refresh_token': refreshToken});
  }
}
