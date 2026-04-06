import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/github.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlight/highlight_core.dart';
import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/cs.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/delphi.dart';
import 'package:highlight/languages/go.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/kotlin.dart';
import 'package:highlight/languages/objectivec.dart';
import 'package:highlight/languages/php.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/ruby.dart';
import 'package:highlight/languages/rust.dart';
import 'package:highlight/languages/swift.dart';
import 'package:highlight/languages/typescript.dart';

class ContestSubmitScreen extends ConsumerStatefulWidget {
  final String contestKey;
  final String problemCode;

  const ContestSubmitScreen({
    super.key,
    required this.contestKey,
    required this.problemCode,
  });

  @override
  ConsumerState<ContestSubmitScreen> createState() =>
      _ContestSubmitScreenState();
}

class _ContestSubmitScreenState extends ConsumerState<ContestSubmitScreen> {
  late final CodeController sourceController = CodeController(
    text: '',
    language: cpp,
  );
  List<String> allowedLanguages = [];
  String? selectedLanguage;
  bool loadingMeta = true;
  bool submitting = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadProblemMeta();
  }

  Future<void> _loadProblemMeta() async {
    setState(() {
      loadingMeta = true;
      error = '';
    });

    try {
      final service = ref.read(contestServiceProvider);
      final detail = await service.fetchContestProblemDetail(
        widget.contestKey,
        widget.problemCode,
      );

      if (!mounted) return;
      setState(() {
        allowedLanguages = detail.allowedLanguages;
        selectedLanguage = detail.allowedLanguages.isNotEmpty
            ? detail.allowedLanguages.first
            : null;
      });
      sourceController.language = _resolveLanguageMode(selectedLanguage);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        error = 'Không tải được cấu hình ngôn ngữ của bài tập';
      });
    } finally {
      if (mounted) {
        setState(() {
          loadingMeta = false;
        });
      }
    }
  }

  Future<void> _submit() async {
    if (submitting) return;

    final messenger = ScaffoldMessenger.maybeOf(context);

    if (selectedLanguage == null) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Không có ngôn ngữ hợp lệ để nộp bài.')),
      );
      return;
    }

    final source = sourceController.text.trim();
    if (source.isEmpty) {
      messenger?.showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập source code.')),
      );
      return;
    }

    setState(() {
      submitting = true;
    });

    try {
      final service = ref.read(contestServiceProvider);
      final res = await service.submitProblem(
        widget.contestKey,
        widget.problemCode,
        selectedLanguage!,
        source,
      );

      if (!mounted) return;
      messenger?.showSnackBar(
        SnackBar(content: Text('${res.detail} (#${res.submissionId})')),
      );
    } catch (e) {
      if (!mounted) return;
      messenger?.showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          submitting = false;
        });
      }
    }
  }

  @override
  void dispose() {
    sourceController.dispose();
    super.dispose();
  }

  Mode _resolveLanguageMode(String? language) {
    final value = language?.trim().toLowerCase() ?? '';

    if (value.contains('python')) return python;
    if (value.contains('typescript') || value == 'ts') return typescript;
    if (value.contains('javascript') || value == 'js') return javascript;
    if (value.contains('kotlin')) return kotlin;
    if (value.contains('objective-c') || value.contains('objc')) {
      return objectivec;
    }
    if (value.contains('swift')) return swift;
    if (value.contains('rust')) return rust;
    if (value.contains('php')) return php;
    if (value.contains('ruby')) return ruby;
    if (value.contains('go')) return go;
    if (value.contains('dart')) return dart;
    if (value.contains('c#') || value.contains('csharp') || value == 'cs') {
      return cs;
    }
    if (value == 'c' || value.startsWith('c ')) return cpp;
    if (value.contains('pascal') || value.contains('delphi')) return delphi;
    if (value.contains('java') && !value.contains('javascript')) return java;
    return cpp;
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Nộp bài ${widget.problemCode}',
      subtitle: 'Chọn ngôn ngữ và gửi lời giải.',
      activeRoute: '/contests',
      breadcrumbLabel: 'Bài ${widget.problemCode}',
      onBreadcrumbTap: () {
        context.go('/contest/${widget.contestKey}/${widget.problemCode}');
      },
      body: loadingMeta
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(Layout.spacing * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (error.isNotEmpty) ...[
                    Text(error, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: Layout.spacing * 2),
                  ],
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Ngôn ngữ',
                      border: OutlineInputBorder(),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: selectedLanguage,
                        items: allowedLanguages
                            .map(
                              (lang) => DropdownMenuItem<String>(
                                value: lang,
                                child: Text(lang),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value;
                          });
                          sourceController.language = _resolveLanguageMode(
                            value,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: Layout.spacing * 2),
                  const Text(
                    'Nguồn bài làm',
                    style: TextStyle(
                      fontSize: Layout.textLg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: Layout.spacing * 2),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(
                          Layout.borderRadiusLg,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CodeTheme(
                        data: CodeThemeData(styles: githubTheme),
                        child: CodeField(
                          controller: sourceController,
                          expands: true,
                          textStyle: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            height: 1.5,
                          ),
                          gutterStyle: GutterStyle(
                            width: 48,
                            background: Colors.grey.shade100,
                            textStyle: GoogleFonts.jetBrainsMono(fontSize: 12),
                          ),
                          padding: const EdgeInsets.all(Layout.spacing * 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Layout.spacing * 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitting ? null : _submit,
                      child: Text(submitting ? 'Đang nộp...' : 'Nộp bài'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
