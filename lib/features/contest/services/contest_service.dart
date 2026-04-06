import 'package:dio/dio.dart';
import 'package:exam_client_flutter/features/contest/models/contest.dart';
import 'package:exam_client_flutter/features/contest/models/problem.dart';

class ContestService {
  final Dio dio;

  ContestService(this.dio);

  Future<List<ContestListItem>> fetchContests() async {
    try {
      final res = await dio.get('contests');
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

  Future<ContestDetailResponse> fetchContestDetail(String key) async {
    try {
      final res = await dio.get('contests/$key');
      return ContestDetailResponse.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['detail'] ?? "Lỗi khi tải chi tiết cuộc thi";
      } else {
        throw "Không kết nối được server";
      }
    }
  }

  Future<void> joinContest(String key) async {
    // API v3 does not expose a dedicated join endpoint.
    return;
  }

  Future<List<ContestProblemItem>> fetchContestProblems(String key) async {
    try {
      final detail = await fetchContestDetail(key);
      if (!detail.canSeeProblems) return [];
      return List<ContestProblemItem>.from(
        detail.problems.map(
          (x) => ContestProblemItem(
            code: x.code,
            name: x.name,
            order: x.order,
            points: x.points,
            partial: x.partial,
            maxSubmissions: x.maxSubmissions,
            label: x.label,
          ),
        ),
      );
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['detail'] ?? 'Không thể tải danh sách bài tập';
      } else {
        throw 'Không kết nối được server';
      }
    }
  }

  Future<ProblemDetail> fetchContestProblemDetail(
    String key,
    String problem,
  ) async {
    try {
      final res = await dio.get('problems/$problem');
      return ProblemDetail.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['detail'] ?? 'Không thể tải chi tiết bài tập';
      } else {
        throw 'Không kết nối được server';
      }
    }
  }

  Future<SubmitProblemResponse> submitProblem(
    String key,
    String problem,
    String languageKey,
    String source,
  ) async {
    try {
      final res = await dio.post(
        'contest/$key/problems/$problem/submit/',
        data: {'language_key': languageKey, 'source': source},
      );
      return SubmitProblemResponse.fromJson(res.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw e.response?.data['detail'] ?? 'Không thể nộp bài';
      } else {
        throw 'Không kết nối được server';
      }
    }
  }
}
