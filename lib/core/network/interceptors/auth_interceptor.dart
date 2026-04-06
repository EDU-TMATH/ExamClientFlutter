import 'package:dio/dio.dart';
import 'package:exam_client_flutter/features/auth/services/token_service.dart';

class AuthInterceptor extends Interceptor {
  final TokenService tokenService;
  final Dio retryDio;

  AuthInterceptor(this.tokenService, {Dio? retryDio})
    : retryDio = retryDio ?? Dio();

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
    final statusCode = err.response?.statusCode;
    final request = err.requestOptions;
    final isAuthEndpoint =
        request.path.contains('auth/login/') ||
        request.path.contains('auth/refresh/');
    final alreadyRetried = request.extra['retried_401'] == true;

    if (statusCode != 401 || isAuthEndpoint || alreadyRetried) {
      handler.next(err);
      return;
    }

    try {
      final newToken = await tokenService.refresh();
      if (newToken == null) {
        await tokenService.clear();
        handler.next(err);
        return;
      }

      request.extra['retried_401'] = true;
      request.headers['Authorization'] = 'Bearer $newToken';

      final response = await retryDio.fetch(request);
      return handler.resolve(response);
    } catch (_) {
      await tokenService.clear();
      handler.next(err);
    }
  }
}
