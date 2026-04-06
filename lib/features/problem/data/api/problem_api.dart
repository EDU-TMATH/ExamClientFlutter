import 'package:dio/dio.dart';
import 'package:exam_client_flutter/features/problem/models/problem.dart';

class ProblemApi {
  final Dio dio;

  ProblemApi(this.dio);

  Future<PracticeProblemPage> fetchProblems({
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    final safePage = page < 1 ? 1 : page;
    final safePageSize = pageSize < 1 ? 20 : pageSize;

    final res = await dio.get(
      'problems',
      queryParameters: {
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        'page': safePage,
        'page_size': safePageSize,
      },
    );

    final data = res.data;
    final list = data is List
        ? data
        : (data is Map<String, dynamic> && data['results'] is List)
        ? data['results'] as List
        : const [];

    final items = List<PracticeProblemListItem>.from(
      list.map(
        (item) => PracticeProblemListItem.fromJson(
          Map<String, dynamic>.from(item as Map),
        ),
      ),
    );

    return PracticeProblemPage(
      items: items,
      page: safePage,
      pageSize: safePageSize,
    );
  }

  Future<PracticeProblemDetail> fetchProblemDetail(String code) async {
    final res = await dio.get('problems/$code');
    return PracticeProblemDetail.fromJson(
      Map<String, dynamic>.from(res.data as Map),
    );
  }

  Future<PracticeSubmitResponse> submitProblem(
    String code,
    String languageKey,
    String source,
  ) async {
    final payload = {'language_key': languageKey, 'source': source};
    final candidates = [
      'problems/$code/submit/',
      'problems/$code/submit',
      'problem/$code/submit/',
      'problem/$code/submit',
    ];

    DioException? lastError;

    for (final endpoint in candidates) {
      try {
        final res = await dio.post(endpoint, data: payload);
        if (res.data is Map<String, dynamic>) {
          return PracticeSubmitResponse.fromJson(
            res.data as Map<String, dynamic>,
          );
        }
        if (res.data is Map) {
          return PracticeSubmitResponse.fromJson(
            Map<String, dynamic>.from(res.data as Map),
          );
        }
        return const PracticeSubmitResponse(detail: 'Submitted successfully');
      } on DioException catch (e) {
        final status = e.response?.statusCode ?? 0;
        if (status == 404 || status == 405) {
          lastError = e;
          continue;
        }
        rethrow;
      }
    }

    if (lastError != null) {
      throw Exception('API hiện tại chưa hỗ trợ nộp bài cho problem public.');
    }

    throw Exception('Không thể nộp bài');
  }
}
