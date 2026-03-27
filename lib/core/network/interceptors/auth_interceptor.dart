import 'package:dio/dio.dart';
import 'package:exam_client_flutter/features/auth/services/token_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenService tokenService;

  AuthInterceptor(this.tokenService);

  @override
  void onRequest(options, handler) async {
    final token = await tokenService.getValidAccessToken();
    options.headers['X-Exam-App'] = 'exam-client';
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, handler) async {
    if (err.response?.statusCode == 401) {
      final newToken = await tokenService.refresh();

      final request = err.requestOptions;

      request.headers['Authorization'] = 'Bearer $newToken';

      final response = await Dio().fetch(request);

      return handler.resolve(response);
    }

    handler.next(err);
  }
}
