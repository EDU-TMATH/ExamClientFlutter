import 'package:exam_client_flutter/features/contest/models/problem.dart';
import 'package:exam_client_flutter/features/problem/models/problem.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContestProblemItem.fromJson', () {
    test('uses title as a fallback when name is absent', () {
      final item = ContestProblemItem.fromJson({
        'code': 'SUMA',
        'title': 'A + B',
        'order': 1,
        'points': 100,
        'partial': false,
        'max_submissions': 3,
        'label': 'A',
      });

      expect(item.title, 'A + B');
      expect(item.maxSubmissions, 3);
    });
  });

  group('ProblemDetail.fromJson', () {
    test('parses contest detail payloads that use title', () {
      final detail = ProblemDetail.fromJson({
        'code': 'SUMA',
        'title': 'A + B',
        'order': 1,
        'points': 100,
        'partial': false,
        'max_submissions': null,
        'label': 'A',
        'statement': '<p>Problem statement</p>',
        'allowed_languages': ['py3', 'cpp17'],
        'io_method': {'type': 'stdio'},
        'time_limit': 1.0,
        'memory_limit': 262144,
      });

      expect(detail.title, 'A + B');
      expect(detail.allowedLanguages, ['py3', 'cpp17']);
      expect(detail.ioMethod['type'], 'stdio');
    });
  });

  group('PracticeProblemPage', () {
    test('infers next page availability from page size', () {
      final page = PracticeProblemPage(
        items: List.generate(
          20,
          (index) => PracticeProblemListItem(
            code: 'P$index',
            name: 'Problem $index',
            group: null,
            types: const [],
            points: 10,
            partial: false,
            isPublic: true,
            isOrganizationPrivate: false,
          ),
        ),
        page: 2,
        pageSize: 20,
      );

      expect(page.page, 2);
      expect(page.hasNextPage, true);
      expect(page.isFirstPage, false);
    });
  });
}
