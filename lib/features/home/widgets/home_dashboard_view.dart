import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/features/auth/models/user.dart';
import 'package:exam_client_flutter/features/home/services/home_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeDashboardView extends StatelessWidget {
  final HomeDashboardData data;

  const HomeDashboardView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 1120;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(Layout.spacing * 3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeroCard(data: data),
              const SizedBox(height: Layout.spacing * 3),
              HomeMetricGrid(data: data, maxWidth: constraints.maxWidth),
              const SizedBox(height: Layout.spacing * 3),
              if (isWide)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          HomeFocusSection(items: data.focusItems),
                          const SizedBox(height: Layout.spacing * 3),
                          HomeSuggestionSection(
                            problems: data.recommendedProblems,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Layout.spacing * 3),
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          HomeSubmissionSection(
                            submissions: data.recentSubmissions,
                          ),
                          const SizedBox(height: Layout.spacing * 3),
                          HomeDataNeedSection(notes: data.notes),
                        ],
                      ),
                    ),
                  ],
                )
              else ...[
                HomeFocusSection(items: data.focusItems),
                const SizedBox(height: Layout.spacing * 3),
                HomeSuggestionSection(problems: data.recommendedProblems),
                const SizedBox(height: Layout.spacing * 3),
                HomeSubmissionSection(submissions: data.recentSubmissions),
                const SizedBox(height: Layout.spacing * 3),
                HomeDataNeedSection(notes: data.notes),
              ],
            ],
          ),
        );
      },
    );
  }
}

class HomeHeroCard extends StatelessWidget {
  final HomeDashboardData data;

  const HomeHeroCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = data.user;
    final name = user.displayName.isNotEmpty ? user.displayName : user.username;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Layout.spacing * 3),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Layout.borderRadiusXl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 860;

          final summary = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: Layout.spacing,
                runSpacing: Layout.spacing,
                children: const [
                  _ToneChip(label: 'LIVE / ACCOUNT'),
                  _ToneChip(label: 'SAMPLE / DASHBOARD'),
                ],
              ),
              const SizedBox(height: Layout.spacing * 2),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: scheme.primaryContainer,
                    foregroundColor: scheme.onPrimaryContainer,
                    child: Text(
                      user.username.isNotEmpty
                          ? user.username[0].toUpperCase()
                          : 'U',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: Layout.spacing * 2),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '@${user.username} • ${_roleLabel(user)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: Layout.spacing * 1.5),
                        Wrap(
                          spacing: Layout.spacing,
                          runSpacing: Layout.spacing,
                          children: [
                            _MetaPill(
                              label: 'Rank',
                              value: user.rank.isEmpty
                                  ? 'Chưa xếp hạng'
                                  : user.rank,
                            ),
                            _MetaPill(
                              label: 'Rating',
                              value: user.rating?.toString() ?? '--',
                            ),
                            _MetaPill(
                              label: 'Solved',
                              value: '${user.problemCount}',
                            ),
                            _MetaPill(
                              label: 'Contest',
                              value: user.currentContestKey ?? 'None',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );

          final actions = Container(
            width: stacked ? double.infinity : 280,
            padding: const EdgeInsets.all(Layout.spacing * 2),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Điều hướng nhanh',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: Layout.spacing * 1.5),
                FilledButton.icon(
                  onPressed: () => context.go('/problems'),
                  icon: const Icon(Icons.code_rounded),
                  label: const Text('Vào kho bài tập'),
                ),
                const SizedBox(height: Layout.spacing),
                OutlinedButton.icon(
                  onPressed: () => context.go(
                    user.currentContestKey == null
                        ? '/contests'
                        : '/contest/${user.currentContestKey}',
                  ),
                  icon: const Icon(Icons.emoji_events_outlined),
                  label: Text(
                    user.currentContestKey == null
                        ? 'Xem contest'
                        : 'Mở contest hiện tại',
                  ),
                ),
                const SizedBox(height: Layout.spacing * 1.5),
                Text(
                  'Cập nhật gần nhất: ${_formatSyncTime(data.generatedAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                summary,
                const SizedBox(height: Layout.spacing * 2),
                actions,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: summary),
              const SizedBox(width: Layout.spacing * 3),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class HomeMetricGrid extends StatelessWidget {
  final HomeDashboardData data;
  final double maxWidth;

  const HomeMetricGrid({super.key, required this.data, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    final columns = maxWidth >= 1180 ? 4 : (maxWidth >= 760 ? 2 : 1);
    final spacing = Layout.spacing * 2;
    final cardWidth = (maxWidth - spacing * (columns - 1)) / columns;
    final user = data.user;

    return Wrap(
      spacing: spacing,
      runSpacing: spacing,
      children: [
        SizedBox(
          width: cardWidth,
          child: _MetricCard(
            icon: Icons.stars_rounded,
            label: 'Điểm tích lũy',
            value: user.points.toStringAsFixed(1),
            caption: 'Từ hồ sơ hiện tại',
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: _MetricCard(
            icon: Icons.trending_up_rounded,
            label: 'Performance',
            value: user.performancePoints.toStringAsFixed(1),
            caption: 'Nhịp tăng trưởng gần đây',
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: _MetricCard(
            icon: Icons.task_alt_rounded,
            label: 'Bài đã giải',
            value: '${user.problemCount}',
            caption: 'Live from profile',
          ),
        ),
        SizedBox(
          width: cardWidth,
          child: _MetricCard(
            icon: Icons.workspace_premium_outlined,
            label: 'Vai trò',
            value: _roleLabel(user),
            caption: user.currentContestKey == null
                ? 'Chưa có contest active'
                : 'Contest: ${user.currentContestKey}',
          ),
        ),
      ],
    );
  }
}

class HomeFocusSection extends StatelessWidget {
  final List<HomeFocusItem> items;

  const HomeFocusSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return _SectionCard(
      title: 'Lộ trình luyện tập',
      badge: 'sample',
      child: Column(
        children: items
            .map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: Layout.spacing * 1.5),
                padding: const EdgeInsets.all(Layout.spacing * 2),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
                  border: Border.all(color: scheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          item.metric,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: Layout.spacing),
                    LinearProgressIndicator(
                      value: item.progress.clamp(0.0, 1.0).toDouble(),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(
                        Layout.borderRadiusSm,
                      ),
                    ),
                    const SizedBox(height: Layout.spacing * 1.25),
                    Text(
                      item.detail,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class HomeSuggestionSection extends StatelessWidget {
  final List<HomeRecommendedProblem> problems;

  const HomeSuggestionSection({super.key, required this.problems});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _SectionCard(
      title: 'Bài nên làm tiếp theo',
      badge: 'sample',
      action: TextButton.icon(
        onPressed: () => context.go('/problems'),
        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
        label: const Text('Mở archive'),
      ),
      child: Column(
        children: problems
            .map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: Layout.spacing * 1.5),
                padding: const EdgeInsets.all(Layout.spacing * 2),
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerLowest,
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
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(
                          Layout.borderRadiusMd,
                        ),
                        border: Border.all(color: scheme.outlineVariant),
                      ),
                      child: Text(
                        item.code,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: Layout.spacing * 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  item.title,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: Layout.spacing),
                              _DifficultyChip(level: item.level),
                            ],
                          ),
                          const SizedBox(height: Layout.spacing),
                          Text(
                            item.note,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: Layout.spacing * 2),
                    Text(
                      '${item.points} pts',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class HomeSubmissionSection extends StatelessWidget {
  final List<HomeRecentSubmission> submissions;

  const HomeSubmissionSection({super.key, required this.submissions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _SectionCard(
      title: 'Submission gần đây',
      badge: 'sample',
      child: Column(
        children: submissions
            .map(
              (item) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundColor: _verdictColor(
                    scheme,
                    item.verdict,
                  ).withValues(alpha: 0.14),
                  child: Icon(
                    _verdictIcon(item.verdict),
                    size: 16,
                    color: _verdictColor(scheme, item.verdict),
                  ),
                ),
                title: Text(
                  '${item.problemCode} • ${item.title}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text(
                  '${item.language} • ${item.relativeTime}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                trailing: Text(
                  item.verdict,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: _verdictColor(scheme, item.verdict),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class HomeDataNeedSection extends StatelessWidget {
  final List<HomePanelNote> notes;

  const HomeDataNeedSection({super.key, required this.notes});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return _SectionCard(
      title: 'Nguồn dữ liệu dashboard',
      badge: 'roadmap',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hiện tại trang chủ dùng kết hợp dữ liệu thật từ hồ sơ và sample cho các khối điều phối luyện tập.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Layout.spacing * 2),
          ...notes.map(
            (note) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: Layout.spacing * 1.5),
              padding: const EdgeInsets.all(Layout.spacing * 2),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest,
                borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ToneChip(label: note.label),
                  const SizedBox(height: Layout.spacing * 1.25),
                  Text(
                    note.title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: Layout.spacing),
                  Text(
                    note.detail,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _roleLabel(User user) {
  if (user.isSuperuser) return 'Superuser';
  if (user.isStaff) return 'Staff';
  return 'User';
}

String _formatSyncTime(DateTime time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

Color _verdictColor(ColorScheme scheme, String verdict) {
  switch (verdict.toUpperCase()) {
    case 'AC':
      return Colors.green.shade700;
    case 'WA':
      return scheme.error;
    case 'TLE':
      return Colors.orange.shade700;
    default:
      return scheme.primary;
  }
}

IconData _verdictIcon(String verdict) {
  switch (verdict.toUpperCase()) {
    case 'AC':
      return Icons.check_rounded;
    case 'WA':
      return Icons.close_rounded;
    case 'TLE':
      return Icons.schedule_rounded;
    default:
      return Icons.circle_outlined;
  }
}

class _MetricCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String caption;

  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(Layout.spacing * 2.5),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: scheme.primary),
          const SizedBox(height: Layout.spacing * 2),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: Layout.spacing),
          Text(
            label,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: Layout.spacing * 0.5),
          Text(
            caption,
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String badge;
  final Widget child;
  final Widget? action;

  const _SectionCard({
    required this.title,
    required this.badge,
    required this.child,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final headerChildren = <Widget>[
      Expanded(
        child: Row(
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: Layout.spacing),
            _ToneChip(label: badge),
          ],
        ),
      ),
    ];

    if (action != null) {
      headerChildren.add(action!);
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Layout.spacing * 2.5),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Layout.borderRadiusXl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: headerChildren),
          const SizedBox(height: Layout.spacing * 2),
          child,
        ],
      ),
    );
  }
}

class _ToneChip extends StatelessWidget {
  final String label;

  const _ToneChip({required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Layout.spacing * 1.25,
        vertical: Layout.spacing * 0.75,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        label.toUpperCase(),
        style: theme.textTheme.labelSmall?.copyWith(
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  final String label;
  final String value;

  const _MetaPill({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Layout.spacing * 1.5,
        vertical: Layout.spacing,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.labelMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
          children: [
            TextSpan(text: '$label: '),
            TextSpan(
              text: value,
              style: TextStyle(
                color: scheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyChip extends StatelessWidget {
  final String level;

  const _DifficultyChip({required this.level});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Color fg;
    Color bg;
    switch (level.toUpperCase()) {
      case 'EASY':
        fg = Colors.green.shade700;
        bg = Colors.green.shade50;
        break;
      case 'HARD':
        fg = Colors.red.shade700;
        bg = Colors.red.shade50;
        break;
      default:
        fg = Colors.orange.shade800;
        bg = Colors.orange.shade50;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Layout.spacing * 1.25,
        vertical: Layout.spacing * 0.75,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Text(
        level,
        style: TextStyle(
          color: fg,
          fontSize: Layout.textXs,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
