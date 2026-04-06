import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/features/problem/utils/problem_statement_html.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:markdown/markdown.dart' as md;

class ProblemStatementView extends StatelessWidget {
  final String content;

  const ProblemStatementView({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    final normalized = normalizeProblemHtml(content);
    final style = MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
      p: const TextStyle(height: 1.6, fontSize: 15),
      code: const TextStyle(fontFamily: 'monospace', fontSize: 13),
      blockquotePadding: const EdgeInsets.all(12),
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildSegments(context, normalized, style),
      ),
    );
  }

  List<Widget> _buildSegments(
    BuildContext context,
    String content,
    MarkdownStyleSheet style,
  ) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    final widgets = <Widget>[];
    final pattern = RegExp(
      r'''<(tex-block|code-block)(?:\s+lang="([^"]+)")?>([\s\S]*?)</\1>''',
    );

    var lastIndex = 0;
    for (final match in pattern.allMatches(content)) {
      final before = content.substring(lastIndex, match.start).trim();
      if (before.isNotEmpty) {
        widgets.add(_buildMarkdownChunk(before, style));
      }

      final tag = match.group(1) ?? '';
      final body = (match.group(3) ?? '').trim();
      if (body.isNotEmpty) {
        if (tag == 'tex-block') {
          widgets.add(_BlockMathView(expression: body));
        } else {
          widgets.add(
            _CodeBlockCard(
              code: body,
              language: match.group(2),
              onCopy: () async {
                await Clipboard.setData(ClipboardData(text: body));
                messenger?.showSnackBar(
                  const SnackBar(content: Text('Đã sao chép code')),
                );
              },
            ),
          );
        }
      }

      lastIndex = match.end;
    }

    final after = content.substring(lastIndex).trim();
    if (after.isNotEmpty) {
      widgets.add(_buildMarkdownChunk(after, style));
    }

    if (widgets.isEmpty) {
      widgets.add(const SizedBox.shrink());
    }

    return widgets;
  }

  Widget _buildMarkdownChunk(String data, MarkdownStyleSheet style) {
    return MarkdownBody(
      data: data,
      selectable: true,
      styleSheet: style,
      inlineSyntaxes: [_TexInlineSyntax()],
      builders: {'tex-inline': _TexInlineBuilder()},
    );
  }
}

class _TexInlineSyntax extends md.InlineSyntax {
  _TexInlineSyntax() : super(r'<tex-inline>([\s\S]+?)</tex-inline>');

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    final expression = (match.group(1) ?? '').trim();
    parser.addNode(md.Element.text('tex-inline', expression));
    return true;
  }
}

class _CodeBlockCard extends StatelessWidget {
  final String code;
  final String? language;
  final Future<void> Function() onCopy;

  const _CodeBlockCard({
    required this.code,
    required this.onCopy,
    this.language,
  });

  @override
  Widget build(BuildContext context) {
    final label = (language == null || language!.trim().isEmpty)
        ? 'CODE'
        : language!.trim().toUpperCase();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: Layout.spacing * 2),
      decoration: BoxDecoration(
        color: gray.shade(50),
        borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
        border: Border.all(color: slate.shade(200)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: Layout.spacing * 2,
              vertical: Layout.spacing * 1.5,
            ),
            color: slate.shade(100),
            child: Row(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: slate.shade(700),
                    fontWeight: FontWeight.w700,
                    fontSize: Layout.textSm,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_all_outlined, size: 16),
                  label: const Text('Sao chép'),
                  style: TextButton.styleFrom(
                    foregroundColor: sky.shade(700),
                    padding: const EdgeInsets.symmetric(
                      horizontal: Layout.spacing * 1.5,
                    ),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(Layout.spacing * 2),
            child: SelectableText(
              code,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.5,
                color: slate.shade(800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TexInlineBuilder extends MarkdownElementBuilder {
  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    final expression = element.textContent.trim();
    if (expression.isEmpty) return null;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Math.tex(
        expression,
        mathStyle: MathStyle.text,
        textStyle: (preferredStyle ?? const TextStyle()).copyWith(
          fontSize: ((preferredStyle?.fontSize ?? 15) * 1.18),
          height: 1.4,
        ),
        onErrorFallback: (error) => Text(
          expression,
          style: preferredStyle?.copyWith(color: Colors.red),
        ),
      ),
    );
  }
}

class _BlockMathView extends StatelessWidget {
  final String expression;

  const _BlockMathView({required this.expression});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DefaultTextStyle.merge(
            style: const TextStyle(fontSize: 20, height: 1.45),
            child: Math.tex(
              expression,
              mathStyle: MathStyle.display,
              textStyle: const TextStyle(fontSize: 20, height: 1.45),
              onErrorFallback: (error) =>
                  Text(expression, style: TextStyle(color: red.shade(600))),
            ),
          ),
        ),
      ),
    );
  }
}
