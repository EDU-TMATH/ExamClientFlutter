import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/exceptions/app_exception.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/features/problem/models/problem.dart';
import 'package:exam_client_flutter/features/problem/widgets/problem_statement_view.dart';
import 'package:exam_client_flutter/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProblemDetailScreen extends ConsumerStatefulWidget {
  final String problemCode;

  const ProblemDetailScreen({super.key, required this.problemCode});

  @override
  ConsumerState<ProblemDetailScreen> createState() =>
      _ProblemDetailScreenState();
}

class _ProblemDetailScreenState extends ConsumerState<ProblemDetailScreen> {
  PracticeProblemDetail? detail;
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadProblem();
  }

  Future<void> _loadProblem() async {
    setState(() {
      loading = true;
      error = '';
    });

    try {
      final repository = ref.read(problemRepositoryProvider);
      final data = await repository.fetchProblemDetail(widget.problemCode);

      if (!mounted) return;
      setState(() {
        detail = data;
      });
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
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: detail?.title ?? 'Problem ${widget.problemCode}',
      subtitle:
          'Focused problem workspace with constraints, language support and latest judging state.',
      activeRoute: '/problems',
      breadcrumbLabel: 'Danh sách bài tập',
      onBreadcrumbTap: () {
        context.go('/problems');
      },
      headerAction: detail?.canSubmit == true
          ? ElevatedButton.icon(
              onPressed: () {
                context.go('/problems/${widget.problemCode}/submit');
              },
              icon: const Icon(Icons.send),
              label: const Text('Nộp bài'),
            )
          : null,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty && detail == null) {
      return Center(child: Text(error));
    }

    final problem = detail;
    if (problem == null) {
      return const Center(child: Text('Không có dữ liệu bài tập.'));
    }

    final latest = problem.latestSubmission;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Layout.spacing * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverviewCard(problem),
          if (problem.types.isNotEmpty) ...[
            const SizedBox(height: Layout.spacing * 3),
            _buildSectionTitle('Phân loại'),
            const SizedBox(height: Layout.spacing),
            Wrap(
              spacing: Layout.spacing,
              runSpacing: Layout.spacing,
              children: problem.types
                  .map(
                    (type) => _tagChip(
                      label: type,
                      background: violet.shade(50),
                      foreground: violet.shade(700),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (problem.allowedLanguages.isNotEmpty) ...[
            const SizedBox(height: Layout.spacing * 3),
            _buildSectionTitle('Ngôn ngữ hỗ trợ'),
            const SizedBox(height: Layout.spacing),
            Wrap(
              spacing: Layout.spacing,
              runSpacing: Layout.spacing,
              children: problem.allowedLanguages
                  .map(
                    (language) => _tagChip(
                      label: language,
                      background: sky.shade(50),
                      foreground: sky.shade(700),
                    ),
                  )
                  .toList(),
            ),
          ],
          if (latest != null) ...[
            const SizedBox(height: Layout.spacing * 3),
            _buildLatestSubmissionCard(latest),
          ],
          const SizedBox(height: Layout.spacing * 3),
          _buildSectionTitle('Đề bài'),
          const SizedBox(height: Layout.spacing),
          SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
                side: BorderSide(color: slate.shade(200)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Layout.spacing * 2),
                child: ProblemStatementView(content: problem.statement),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(PracticeProblemDetail problem) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Layout.spacing * 3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Layout.borderRadiusXl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: Layout.spacing,
            runSpacing: Layout.spacing,
            children: [
              _softBadge(Icons.tag_rounded, problem.code),
              if (problem.group != null && problem.group!.isNotEmpty)
                _softBadge(Icons.folder_open_rounded, problem.group!),
              _softBadge(
                problem.canSubmit
                    ? Icons.send_rounded
                    : Icons.visibility_rounded,
                problem.canSubmit ? 'Có thể nộp' : 'Chỉ xem',
              ),
              _softBadge(
                problem.isPublic ? Icons.public_rounded : Icons.lock_rounded,
                problem.isPublic ? 'Public' : 'Private',
              ),
            ],
          ),
          const SizedBox(height: Layout.spacing * 2),
          Text(
            problem.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
          if (problem.authors.isNotEmpty || problem.curators.isNotEmpty) ...[
            const SizedBox(height: Layout.spacing),
            Text(
              [
                if (problem.authors.isNotEmpty)
                  'Tác giả: ${problem.authors.join(', ')}',
                if (problem.curators.isNotEmpty)
                  'Quản lý: ${problem.curators.join(', ')}',
              ].join(' • '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: Layout.spacing * 3),
          Wrap(
            spacing: Layout.spacing * 2,
            runSpacing: Layout.spacing * 2,
            children: [
              _metricCard(
                icon: Icons.stars_rounded,
                label: 'Điểm',
                value: _formatPoints(problem.points),
                tone: yellow.shade(50),
                accent: yellow.shade(700),
              ),
              _metricCard(
                icon: Icons.timer_outlined,
                label: 'Time limit',
                value: '${problem.timeLimit}s',
                tone: sky.shade(50),
                accent: sky.shade(700),
              ),
              _metricCard(
                icon: Icons.memory_rounded,
                label: 'Memory',
                value: '${problem.memoryLimit} KB',
                tone: violet.shade(50),
                accent: violet.shade(700),
              ),
              _metricCard(
                icon: Icons.code_rounded,
                label: 'Ngôn ngữ',
                value: '${problem.allowedLanguages.length}',
                tone: green.shade(50),
                accent: green.shade(700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLatestSubmissionCard(PracticeLatestSubmission latest) {
    final result = latest.result ?? latest.status ?? 'N/A';
    final tone = result == 'AC' ? green : orange;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Layout.spacing * 2),
      decoration: BoxDecoration(
        color: tone.shade(50),
        borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
        border: Border.all(color: tone.shade(200)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: tone.shade(100),
            foregroundColor: tone.shade(700),
            child: const Icon(Icons.history_rounded),
          ),
          const SizedBox(width: Layout.spacing * 2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Submission gần nhất: $result',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: slate.shade(900),
                  ),
                ),
                const SizedBox(height: Layout.spacing * 0.5),
                Text(
                  latest.date == null
                      ? 'Chưa có thời gian chấm'
                      : latest.date!.toLocal().toString(),
                  style: TextStyle(color: slate.shade(600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);

    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
    );
  }

  Widget _softBadge(IconData icon, String label) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Layout.spacing * 1.5,
        vertical: Layout.spacing,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: scheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: scheme.onSurface,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _tagChip({
    required String label,
    required Color background,
    required Color foreground,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Layout.spacing * 1.5,
        vertical: Layout.spacing,
      ),
      decoration: BoxDecoration(
        color: background.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
        border: Border.all(color: foreground.withValues(alpha: 0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(color: foreground, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _metricCard({
    required IconData icon,
    required String label,
    required String value,
    required Color tone,
    required Color accent,
  }) {
    final theme = Theme.of(context);

    return Container(
      width: 168,
      padding: const EdgeInsets.all(Layout.spacing * 2),
      decoration: BoxDecoration(
        color: tone.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
        border: Border.all(color: accent.withValues(alpha: 0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accent, size: 18),
          const SizedBox(height: Layout.spacing * 1.25),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Layout.spacing * 0.5),
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  String _formatPoints(double points) {
    return points == points.roundToDouble()
        ? points.toStringAsFixed(0)
        : points.toStringAsFixed(1);
  }
}
