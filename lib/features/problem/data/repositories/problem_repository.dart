import 'package:dio/dio.dart';
import 'package:exam_client_flutter/core/exceptions/app_exception.dart';
import 'package:exam_client_flutter/features/problem/data/api/problem_api.dart';
import 'package:exam_client_flutter/features/problem/models/problem.dart';

class ProblemRepository {
  final ProblemApi api;

  ProblemRepository(this.api);

  Future<PracticeProblemPage> fetchProblems({
    String? search,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      return await api.fetchProblems(
        search: search,
        page: page,
        pageSize: pageSize,
      );
    } on DioException catch (e) {
      throw _mapError(e, 'Không thể tải danh sách bài tập');
    } catch (e) {
      throw AppException(
        _normalizeMessage(e, 'Không thể tải danh sách bài tập'),
      );
    }
  }

  Future<PracticeProblemDetail> fetchProblemDetail(String code) async {
    try {
      return await api.fetchProblemDetail(code);
    } on DioException catch (e) {
      throw _mapError(e, 'Không thể tải chi tiết bài tập');
    } catch (e) {
      throw AppException(
        _normalizeMessage(e, 'Không thể tải chi tiết bài tập'),
      );
    }
  }

  Future<PracticeSubmitResponse> submitProblem(
    String code,
    String languageKey,
    String source,
  ) async {
    try {
      return await api.submitProblem(code, languageKey, source);
    } on DioException catch (e) {
      throw _mapError(e, 'Không thể nộp bài');
    } catch (e) {
      throw AppException(_normalizeMessage(e, 'Không thể nộp bài'));
    }
  }

  AppException _mapError(DioException e, String fallback) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.unknown) {
      return NetworkException();
    }

    final status = e.response?.statusCode;

    if (status != null && status >= 500) {
      return ServerException();
    }

    if (e.response?.data is Map<String, dynamic>) {
      final data = e.response!.data as Map<String, dynamic>;
      return AppException(data['detail']?.toString() ?? fallback);
    }

    return AppException(
      e.response != null ? fallback : 'Không kết nối được server',
    );
  }

  String _normalizeMessage(Object error, String fallback) {
    final text = error.toString();
    if (text.startsWith('Exception: ')) {
      return text.substring('Exception: '.length);
    }
    return text.isEmpty ? fallback : text;
  }
}
