import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/features/contest/models/problem.dart';
import 'package:exam_client_flutter/features/problem/widgets/problem_statement_view.dart';
import 'package:exam_client_flutter/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContestProblemDetailScreen extends ConsumerStatefulWidget {
  final String contestKey;
  final String problemCode;

  const ContestProblemDetailScreen({
    super.key,
    required this.contestKey,
    required this.problemCode,
  });

  @override
  ConsumerState<ContestProblemDetailScreen> createState() =>
      _ContestProblemDetailScreenState();
}

class _ContestProblemDetailScreenState
    extends ConsumerState<ContestProblemDetailScreen> {
  ProblemDetail? detail;
  bool loading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future<void> _loadDetail() async {
    setState(() {
      loading = true;
      error = '';
    });

    try {
      final service = ref.read(contestServiceProvider);
      final data = await service.fetchContestProblemDetail(
        widget.contestKey,
        widget.problemCode,
      );

      if (!mounted) return;
      setState(() {
        detail = data;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        error = 'Không tải được chi tiết bài tập';
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
      title: 'Bài ${widget.problemCode}',
      subtitle:
          'Focused contest problem workspace with clear constraints and rapid access to submit.',
      activeRoute: '/contests',
      breadcrumbLabel: 'Contest ${widget.contestKey}',
      onBreadcrumbTap: () {
        context.go('/contest/${widget.contestKey}');
      },
      headerAction: ElevatedButton.icon(
        onPressed: () {
          context.go(
            '/contest/${widget.contestKey}/${widget.problemCode}/submit',
          );
        },
        icon: const Icon(Icons.send_rounded),
        label: const Text('Nộp bài'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error.isNotEmpty) {
      return Center(child: Text(error));
    }

    final d = detail;
    if (d == null) {
      return const Center(child: Text('Không có dữ liệu bài tập'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Layout.spacing * 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Layout.spacing * 3),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(Layout.borderRadiusXl),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: Layout.spacing,
                  runSpacing: Layout.spacing,
                  children: [
                    _badge(Icons.tag_rounded, d.code),
                    if ((d.label ?? '').isNotEmpty)
                      _badge(Icons.label_rounded, d.label!),
                    _badge(
                      d.partial
                          ? Icons.pie_chart_rounded
                          : Icons.check_circle_rounded,
                      d.partial ? 'Partial' : 'Full',
                    ),
                  ],
                ),
                const SizedBox(height: Layout.spacing * 2),
                Text(
                  d.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: Layout.spacing * 3),
                Wrap(
                  spacing: Layout.spacing * 2,
                  runSpacing: Layout.spacing * 2,
                  children: [
                    _metricCard(
                      'Điểm',
                      '${d.points}',
                      Icons.stars_rounded,
                      yellow.shade(50),
                      yellow.shade(700),
                    ),
                    _metricCard(
                      'Time',
                      '${d.timeLimit}s',
                      Icons.timer_outlined,
                      sky.shade(50),
                      sky.shade(700),
                    ),
                    _metricCard(
                      'Memory',
                      '${d.memoryLimit} MB',
                      Icons.memory_rounded,
                      violet.shade(50),
                      violet.shade(700),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Layout.spacing * 3),
          Text(
            'Đề bài',
            style: TextStyle(
              fontSize: Layout.textLg,
              fontWeight: FontWeight.w700,
              color: slate.shade(900),
            ),
          ),
          const SizedBox(height: Layout.spacing * 1.5),
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
                child: ProblemStatementView(content: d.statement),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String label) {
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

  Widget _metricCard(
    String label,
    String value,
    IconData icon,
    Color tone,
    Color accent,
  ) {
    final theme = Theme.of(context);

    return Container(
      width: 160,
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
}
