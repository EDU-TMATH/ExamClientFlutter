import 'package:dio/dio.dart';

class DioClient {
  final Dio dio;

  DioClient() : dio = Dio(BaseOptions(baseUrl: "http://171.244.63.31:8443"));
}
