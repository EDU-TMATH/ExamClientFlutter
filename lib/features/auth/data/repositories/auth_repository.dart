import 'package:dio/dio.dart';
import 'package:exam_client_flutter/core/exceptions/app_exception.dart';
import 'package:exam_client_flutter/core/exceptions/auth_exception.dart';
import 'package:exam_client_flutter/features/auth/data/api/auth_api.dart';
import 'package:exam_client_flutter/features/auth/services/token_service.dart';

class AuthRepository {
  final AuthApi api;
  final TokenService tokenService;

  AuthRepository(this.api, this.tokenService);

  Future<void> login(String username, String password) async {
    try {
      final token = await api.login(username, password);
      await tokenService.save(token);
    } on DioException catch (e) {
      throw _mapError(e);
    }
  }

  Future<void> logout() async {
    try {
      final token = await tokenService.getToken();

      if (token?.refresh != null) {
        await api.logout(token!.refresh);
      }
    } catch (_) {
      // 👉 ignore lỗi logout (network fail vẫn logout local)
    }

    await tokenService.clear();
  }

  Future<bool> isLoggedIn() async {
    final token = await tokenService.getValidAccessToken();
    return token != null;
  }

  AppException _mapError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.unknown) {
      return NetworkException();
    }

    final status = e.response?.statusCode;

    if (status == 401) {
      return UnauthorizedException();
    }

    if (status != null && status >= 500) {
      return ServerException();
    }

    return AppException("Có lỗi xảy ra");
  }
}
