import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/exceptions/app_exception.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/features/problem/models/problem.dart';
import 'package:exam_client_flutter/widgets/app_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProblemListScreen extends ConsumerStatefulWidget {
  const ProblemListScreen({super.key});

  @override
  ConsumerState<ProblemListScreen> createState() => _ProblemListScreenState();
}

class _ProblemListScreenState extends ConsumerState<ProblemListScreen> {
  static const int _pageSize = 20;

  final TextEditingController _searchController = TextEditingController();
  List<PracticeProblemListItem> problems = [];
  bool loading = true;
  bool hasNextPage = false;
  int currentPage = 1;
  String error = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadProblems();
      }
    });
  }

  Future<void> _loadProblems({String? query, int? page}) async {
    final requestedQuery = query ?? _searchController.text;
    final requestedPage = page ?? currentPage;
    final previousProblems = List<PracticeProblemListItem>.from(problems);
    final previousPage = currentPage;

    setState(() {
      loading = true;
      error = '';
    });

    try {
      final repository = ref.read(problemRepositoryProvider);
      final data = await repository.fetchProblems(
        search: requestedQuery,
        page: requestedPage,
        pageSize: _pageSize,
      );

      if (!mounted) return;

      if (data.items.isEmpty && requestedPage > 1) {
        setState(() {
          problems = previousProblems;
          currentPage = previousPage;
          hasNextPage = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đã tới trang cuối.')));
        return;
      }

      setState(() {
        problems = data.items;
        currentPage = data.page;
        hasNextPage = data.hasNextPage;
      });
    } on AppException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.message;
        problems = [];
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        problems = [];
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
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppLayout(
      title: 'Bài tập luyện tập',
      subtitle:
          'Public archive for practice, search, reading and fast submission.',
      activeRoute: '/problems',
      headerAction: ElevatedButton.icon(
        onPressed: () => _loadProblems(page: currentPage),
        icon: const Icon(Icons.refresh),
        label: const Text('Làm mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Layout.spacing * 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(Layout.spacing * 2),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (value) =>
                              _loadProblems(query: value, page: 1),
                          decoration: InputDecoration(
                            labelText: 'Search problem',
                            hintText: 'code, title, tag...',
                            suffixIcon: IconButton(
                              onPressed: () => _loadProblems(),
                              icon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Layout.spacing * 2),
                      OutlinedButton(
                        onPressed: () {
                          _searchController.clear();
                          _loadProblems(query: '', page: 1);
                        },
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                  const SizedBox(height: Layout.spacing * 1.5),
                  Wrap(
                    spacing: Layout.spacing,
                    runSpacing: Layout.spacing,
                    children: [
                      _statusChip(loading ? 'SYNCING' : 'PAGE $currentPage'),
                      _statusChip(
                        loading ? 'FETCHING' : '${problems.length} RESULTS',
                      ),
                      if (_searchController.text.trim().isNotEmpty)
                        _statusChip(
                          'FILTER ${_searchController.text.trim().toUpperCase()}',
                        ),
                    ],
                  ),
                ],
              ),
            ),
            if (error.isNotEmpty) ...[
              const SizedBox(height: Layout.spacing * 1.5),
              Text(error, style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: Layout.spacing * 2),
            Expanded(child: _buildList()),
            const SizedBox(height: Layout.spacing * 1.5),
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (problems.isEmpty) {
      return const Center(child: Text('Chưa có bài tập phù hợp.'));
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ListView.separated(
      itemCount: problems.length,
      separatorBuilder: (_, _) => const SizedBox(height: Layout.spacing * 1.25),
      itemBuilder: (context, index) {
        final problem = problems[index];
        final meta = <String>[
          if (problem.group != null && problem.group!.isNotEmpty)
            'Nhóm: ${problem.group}',
          if (problem.types.isNotEmpty) problem.types.join(' • '),
        ].join(' • ');

        return Material(
          color: scheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
          child: InkWell(
            onTap: () => context.go('/problems/${problem.code}'),
            borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
            child: Container(
              padding: const EdgeInsets.all(Layout.spacing * 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: Layout.spacing * 1.5,
                      vertical: Layout.spacing,
                    ),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(
                        Layout.borderRadiusMd,
                      ),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Text(
                      problem.code,
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  const SizedBox(width: Layout.spacing * 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          problem.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (meta.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            meta,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: Layout.spacing * 2),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${_formatPoints(problem.points)} pts',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Layout.spacing * 1.5,
                          vertical: Layout.spacing * 0.5,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(
                            Layout.borderRadiusMd,
                          ),
                        ),
                        child: Text(
                          problem.partial ? 'PARTIAL' : 'FULL',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPagination() {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: !loading && currentPage > 1
              ? () => _loadProblems(page: currentPage - 1)
              : null,
          icon: const Icon(Icons.chevron_left),
          label: const Text('Trang trước'),
        ),
        const Spacer(),
        Text(
          'Trang $currentPage',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        OutlinedButton.icon(
          onPressed: !loading && hasNextPage
              ? () => _loadProblems(page: currentPage + 1)
              : null,
          icon: const Icon(Icons.chevron_right),
          label: const Text('Trang sau'),
        ),
      ],
    );
  }

  Widget _statusChip(String text) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Layout.spacing * 1.5,
        vertical: Layout.spacing * 0.75,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  String _formatPoints(double points) {
    return points == points.roundToDouble()
        ? points.toStringAsFixed(0)
        : points.toStringAsFixed(1);
  }
}
