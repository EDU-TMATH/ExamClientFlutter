import 'package:dio/dio.dart';
import 'package:exam_client_flutter/core/di.dart';

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(baseUrl: "http://171.244.63.31:8443")) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          options.headers['X-Exam-App'] = 'exam-client';
          final token = await tokenStorage.getToken();
          if (token != null && !tokenService.isExpired(token)) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
    );
  }
}
