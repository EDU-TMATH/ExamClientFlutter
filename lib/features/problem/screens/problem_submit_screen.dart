import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/exceptions/app_exception.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/features/problem/models/problem.dart';
import 'package:exam_client_flutter/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_code_editor/flutter_code_editor.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
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

class ProblemSubmitScreen extends ConsumerStatefulWidget {
  final String problemCode;

  const ProblemSubmitScreen({super.key, required this.problemCode});

  @override
  ConsumerState<ProblemSubmitScreen> createState() =>
      _ProblemSubmitScreenState();
}

class _ProblemSubmitScreenState extends ConsumerState<ProblemSubmitScreen> {
  late final CodeController sourceController = CodeController(
    text: '',
    language: cpp,
  );
  PracticeProblemDetail? detail;
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
      final repository = ref.read(problemRepositoryProvider);
      final data = await repository.fetchProblemDetail(widget.problemCode);

      if (!mounted) return;
      setState(() {
        detail = data;
        allowedLanguages = data.allowedLanguages;
        selectedLanguage = data.allowedLanguages.isNotEmpty
            ? data.allowedLanguages.first
            : null;
      });
      sourceController.language = _resolveLanguageMode(selectedLanguage);
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.message;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
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
    if (submitting || detail?.canSubmit != true) return;

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
      final repository = ref.read(problemRepositoryProvider);
      final res = await repository.submitProblem(
        widget.problemCode,
        selectedLanguage!,
        source,
      );

      if (!mounted) return;
      messenger?.showSnackBar(
        SnackBar(
          content: Text(
            res.submissionId == null
                ? res.detail
                : '${res.detail} (#${res.submissionId})',
          ),
        ),
      );
    } on AppException catch (e) {
      if (!mounted) return;
      messenger?.showSnackBar(SnackBar(content: Text(e.message)));
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

    if (value.contains('py')) return python;
    // print('Resolving language mode for: "$value"');
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
      subtitle: 'Nộp lời giải cho problem public luyện tập.',
      activeRoute: '/problems',
      breadcrumbLabel: 'Problem ${widget.problemCode}',
      onBreadcrumbTap: () {
        context.go('/problems/${widget.problemCode}');
      },
      body: loadingMeta
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(Layout.spacing * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (detail != null)
                    Text(
                      detail!.title,
                      style: const TextStyle(
                        fontSize: Layout.textLg,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (error.isNotEmpty) ...[
                    const SizedBox(height: Layout.spacing * 1.5),
                    Text(error, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: Layout.spacing * 2),
                  if (detail?.canSubmit == false)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Layout.spacing * 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(
                          Layout.borderRadiusLg,
                        ),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: const Text(
                        'Tài khoản hiện tại chưa có quyền nộp bài cho problem này.',
                      ),
                    ),
                  if (detail?.canSubmit == false)
                    const SizedBox(height: Layout.spacing * 2),
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
                        onChanged: detail?.canSubmit == true
                            ? (value) {
                                setState(() {
                                  selectedLanguage = value;
                                });
                                sourceController.language =
                                    _resolveLanguageMode(value);
                              }
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: Layout.spacing * 2),
                  const Text(
                    'Source code',
                    style: TextStyle(
                      fontSize: Layout.textLg,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: Layout.spacing),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xff282c34),
                        border: Border.all(color: const Color(0xff3e4451)),
                        borderRadius: BorderRadius.circular(
                          Layout.borderRadiusLg,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: CodeTheme(
                        data: CodeThemeData(styles: atomOneDarkTheme),
                        child: CodeField(
                          controller: sourceController,
                          expands: true,
                          enabled: detail?.canSubmit == true,
                          textStyle: GoogleFonts.jetBrainsMono(
                            fontSize: 14,
                            height: 1.5,
                            color: const Color(0xffabb2bf),
                          ),
                          gutterStyle: GutterStyle(
                            width: 48,
                            background: const Color(0xff21252b),
                            textStyle: GoogleFonts.jetBrainsMono(
                              fontSize: 12,
                              color: const Color(0xff636d83),
                            ),
                          ),
                          padding: const EdgeInsets.all(Layout.spacing * 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Layout.spacing * 2),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: submitting || detail?.canSubmit != true
                          ? null
                          : _submit,
                      icon: const Icon(Icons.send),
                      label: Text(submitting ? 'Đang nộp...' : 'Nộp bài'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
