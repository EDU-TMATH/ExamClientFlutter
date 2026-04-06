import 'package:exam_client_flutter/features/problem/widgets/problem_statement_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders tex-inline tags as math widgets', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProblemStatementView(
            content:
                'Cho hai số nguyên dương <tex-inline>n</tex-inline> và <tex-inline>m</tex-inline>.',
          ),
        ),
      ),
    );

    expect(find.byType(Math), findsNWidgets(2));
    expect(find.textContaining('<tex-inline>'), findsNothing);
  });

  testWidgets('renders fenced code blocks with a copy button', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProblemStatementView(
            content: '```cpp\nint main() { return 0; }\n```',
          ),
        ),
      ),
    );

    expect(find.text('Sao chép'), findsOneWidget);
    expect(find.textContaining('int main()'), findsOneWidget);
  });
}
