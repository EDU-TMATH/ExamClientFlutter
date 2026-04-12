import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/v3/'));
}
