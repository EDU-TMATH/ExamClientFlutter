import 'package:exam_client_flutter/features/problem/utils/problem_statement_html.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('normalizeProblemHtml', () {
    test('replaces KaTeX HTML wrappers with tex-inline tags', () {
      const rawHtml = '''
<p>Cho công thức <span class="katex"><span class="katex-mathml"><math><semantics><mrow></mrow><annotation encoding="application/x-tex">x^2 + y^2</annotation></semantics></math></span><span class="katex-html" aria-hidden="true">rendered</span></span>.</p>
''';

      final normalized = normalizeProblemHtml(rawHtml);

      expect(normalized, contains('<tex-inline>x^2 + y^2</tex-inline>'));
      expect(normalized, isNot(contains('katex-html')));
    });

    test('replaces display math scripts with tex-block tags', () {
      const rawHtml =
          '<p>Test</p><script type="math/tex; mode=display">\\int_0^1 x dx</script>';

      final normalized = normalizeProblemHtml(rawHtml);

      expect(normalized, contains('<tex-block>\\int_0^1 x dx</tex-block>'));
    });

    test('replaces markdown math delimiters with tex tags', () {
      const rawMarkdown = '''Inline \$a^2+b^2=c^2\$ and block:

after

\$\$\\sum_{i=1}^{n} i\$\$''';

      final normalized = normalizeProblemHtml(rawMarkdown);

      expect(normalized, contains('<tex-inline>a^2+b^2=c^2</tex-inline>'));
      expect(normalized, contains('<tex-block>\\sum_{i=1}^{n} i</tex-block>'));
    });

    test('replaces indented code blocks with code-block tags', () {
      const rawMarkdown = 'Mẫu code:\n\n\tfinal x = 1;\n\tprint(x);';

      final normalized = normalizeProblemHtml(rawMarkdown);

      expect(
        normalized,
        contains('<code-block>final x = 1;\nprint(x);</code-block>'),
      );
    });
  });
}
