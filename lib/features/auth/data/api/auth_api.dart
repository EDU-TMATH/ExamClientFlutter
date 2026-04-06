import 'package:dio/dio.dart';
import 'package:exam_client_flutter/features/auth/models/token.dart';
import 'package:exam_client_flutter/features/auth/models/user.dart';

class AuthApi {
  final Dio dio;

  AuthApi(this.dio);

  Future<User> me() async {
    final res = await dio.get('me');
    return User.fromJson(res.data);
  }

  Future<Token> refresh(String refreshToken) async {
    final res = await dio.post(
      'auth/refresh',
      data: {'refresh_token': refreshToken},
    );
    return Token.fromJson(res.data);
  }

  Future<Token> login(String username, String password) async {
    final res = await dio.post(
      'auth/login',
      data: {'username': username, 'password': password},
    );

    return Token.fromJson(res.data);
  }

  Future<void> logout(String refreshToken) async {
    await dio.post('auth/logout', data: {'refresh_token': refreshToken});
  }
}
