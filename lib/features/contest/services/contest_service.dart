import 'package:dio/dio.dart';
import 'package:exam_client_flutter/features/contest/models/contest.dart';

class ContestService {
  final Dio dio;

  ContestService(this.dio);

  Future fetchContests() async {
    try {
      final res = await dio.get('/api/contests/');
      return List<ContestListItem>.from(
        res.data.map((x) => ContestListItem.fromJson(x)),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['detail'] ?? "Lỗi khi tải danh sách cuộc thi";
      } else {
        throw "Không kết nối được server";
      }
    }
  }
}
