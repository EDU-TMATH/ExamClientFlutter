import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient()
    : dio = Dio(BaseOptions(baseUrl: 'http://100.125.23.47:8000/api/v3/'));
}
