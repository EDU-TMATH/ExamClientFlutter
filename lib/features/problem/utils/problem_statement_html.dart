String normalizeProblemHtml(String input) {
  var result = input.replaceAll('\r\n', '\n');

  result = result.replaceAllMapped(
    RegExp(
      r"""<script[^>]*type=['"]math/tex; mode=display['"][^>]*>([\s\S]*?)</script>""",
      caseSensitive: false,
    ),
    (match) =>
        '\n<tex-block>${_decodeHtml(match.group(1) ?? '')}</tex-block>\n',
  );

  result = result.replaceAllMapped(
    RegExp(
      r"""<script[^>]*type=['"]math/tex['"][^>]*>([\s\S]*?)</script>""",
      caseSensitive: false,
    ),
    (match) => '<tex-inline>${_decodeHtml(match.group(1) ?? '')}</tex-inline>',
  );

  result = result.replaceAllMapped(
    RegExp(
      r"""<span class=['"][^'"]*katex-display[^'"]*['"][\s\S]*?<annotation encoding=['"]application/x-tex['"]>([\s\S]*?)</annotation>[\s\S]*?</span>""",
      caseSensitive: false,
    ),
    (match) =>
        '\n<tex-block>${_decodeHtml(match.group(1) ?? '')}</tex-block>\n',
  );

  result = result.replaceAllMapped(
    RegExp(
      r"""<span class=['"][^'"]*katex[^'"]*['"][\s\S]*?<annotation encoding=['"]application/x-tex['"]>([\s\S]*?)</annotation>[\s\S]*?</span>""",
      caseSensitive: false,
    ),
    (match) => '<tex-inline>${_decodeHtml(match.group(1) ?? '')}</tex-inline>',
  );

  result = result.replaceAllMapped(
    RegExp(r'\\\[([\s\S]*?)\\\]'),
    (match) => '\n<tex-block>${(match.group(1) ?? '').trim()}</tex-block>\n',
  );

  result = result.replaceAllMapped(
    RegExp(r'\\\(([\s\S]*?)\\\)'),
    (match) => '<tex-inline>${(match.group(1) ?? '').trim()}</tex-inline>',
  );

  result = result.replaceAllMapped(
    RegExp(r'\$\$([\s\S]*?)\$\$'),
    (match) => '\n<tex-block>${(match.group(1) ?? '').trim()}</tex-block>\n',
  );

  result = result.replaceAllMapped(
    RegExp(r'(?<!\$)\$([^\$\n]+?)\$(?!\$)'),
    (match) => '<tex-inline>${(match.group(1) ?? '').trim()}</tex-inline>',
  );

  result = result.replaceAllMapped(
    RegExp(r'```([^\n`]*)\n([\s\S]*?)```'),
    (match) => _buildCodeBlockTag(
      match.group(2) ?? '',
      language: match.group(1)?.trim(),
    ),
  );

  result = result.replaceAllMapped(
    RegExp(r'((?:^(?:\t| {4}).*(?:\n|$))+)', multiLine: true),
    (match) {
      final block = (match.group(1) ?? '')
          .replaceAll(RegExp(r'^(?:\t| {4})', multiLine: true), '')
          .trimRight();
      return block.isEmpty ? '' : _buildCodeBlockTag(block);
    },
  );

  result = result
      .replaceAll(RegExp(r'<span[^>]*>', caseSensitive: false), '')
      .replaceAll(RegExp(r'</span>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n\n')
      .replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '')
      .replaceAll(RegExp(r'<li[^>]*>', caseSensitive: false), '- ')
      .replaceAll(RegExp(r'</li>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</?(ul|ol)[^>]*>', caseSensitive: false), '\n')
      .replaceAllMapped(
        RegExp(
          r'''<pre[^>]*><code(?:[^>]*class=["']language-([^"']+)["'])?[^>]*>([\s\S]*?)</code></pre>''',
          caseSensitive: false,
        ),
        (match) => _buildCodeBlockTag(
          match.group(2) ?? '',
          language: match.group(1)?.trim(),
        ),
      )
      .replaceAllMapped(
        RegExp(r'<code[^>]*>([\s\S]*?)</code>', caseSensitive: false),
        (match) => '` ${_decodeHtml(match.group(1) ?? '').trim()} `',
      );

  return _decodeHtml(result).trim();
}

String _buildCodeBlockTag(String source, {String? language}) {
  final lang = (language == null || language.isEmpty)
      ? ''
      : ' lang="${language.toLowerCase()}"';
  final code = _decodeHtml(source).trimRight();
  return '\n<code-block$lang>$code</code-block>\n';
}

String _decodeHtml(String value) {
  return value
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"')
      .replaceAll('&#39;', "'");
}
