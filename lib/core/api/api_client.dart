import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;

  ApiClient() : dio = Dio(BaseOptions(baseUrl: "http://171.244.63.31:8443")) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['X-Exam-App'] = 'exam-client';
          handler.next(options);
        },
      ),
    );
  }
}
