import 'dart:async';
import 'package:exam_client_flutter/features/contest/models/contest.dart';
import 'package:flutter/material.dart';

class ContestCard extends StatefulWidget {
  final ContestListItem contest;
  final bool showAction;
  final String actionLabel;
  final bool isActiveContest;
  final Function(String key)? onJoin;
  final Function(String key)? onCountdownFinished;

  const ContestCard({
    super.key,
    required this.contest,
    this.showAction = true,
    this.actionLabel = "Tham gia",
    this.isActiveContest = false,
    this.onJoin,
    this.onCountdownFinished,
  });

  @override
  State<ContestCard> createState() => _ContestCardState();
}

class _ContestCardState extends State<ContestCard> {
  Duration countdown = Duration.zero;
  String label = "ended";
  String lastPhase = "ended";

  Timer? timer;

  @override
  void initState() {
    super.initState();
    updateCountdown();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      updateCountdown();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateCountdown() {
    final now = DateTime.now();

    String phase = "ended";

    if (now.isBefore(widget.contest.startTime)) {
      phase = "before-start";
      label = "start";
      countdown = widget.contest.startTime.difference(now);
    } else if (now.isBefore(widget.contest.endTime)) {
      phase = "in-progress";
      label = "end";
      countdown = widget.contest.endTime.difference(now);
    } else {
      phase = "ended";
      label = "ended";
      countdown = Duration.zero;
    }

    if (lastPhase != phase && lastPhase != "ended") {
      widget.onCountdownFinished?.call(widget.contest.key);
    }

    lastPhase = phase;

    if (mounted) setState(() {});
  }

  String formatTime(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  Color _statusColor(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (label == "start") return Colors.orange.shade700;
    if (label == "end") return Colors.green.shade700;
    return scheme.onSurfaceVariant;
  }

  String _statusText() {
    if (label == "start") return "Bắt đầu sau ${formatTime(countdown)}";
    if (label == "end") return "Kết thúc sau ${formatTime(countdown)}";
    return "Đã kết thúc";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final statusColor = _statusColor(context);
    final visibilityColor =
        widget.contest.isPrivate || widget.contest.isOrganizationPrivate
        ? Colors.deepPurple.shade700
        : Colors.blue.shade700;
    final actionButton = widget.showAction
        ? label == "start"
              ? _lockedButton(context)
              : FilledButton.icon(
                  onPressed: () {
                    widget.onJoin?.call(widget.contest.key);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                  label: Text(widget.actionLabel),
                )
        : null;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        color: scheme.surfaceContainerLow,
        // color: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 520;
              // print("MainAxisSize: ${MainAxisSize.min}");
              return Column(
                // mainAxisSize: MainAxisSize.min,
                // spacing: 16,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (isCompact) ...[
                    Text(
                      widget.contest.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    // const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _badge(
                          text: _statusText(),
                          color: statusColor.withValues(alpha: 0.12),
                          textColor: statusColor,
                          borderColor: statusColor.withValues(alpha: 0.24),
                        ),
                        _badge(
                          text: _visibilityText(),
                          color: visibilityColor.withValues(alpha: 0.12),
                          textColor: visibilityColor,
                          borderColor: visibilityColor.withValues(alpha: 0.22),
                        ),
                        if (widget.contest.isRated)
                          _badge(
                            text: 'Rated',
                            color: Colors.indigo.shade100,
                            textColor: Colors.indigo.shade700,
                            borderColor: Colors.indigo.shade200,
                          ),
                      ],
                    ),
                  ] else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.contest.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _badge(
                                    text: _statusText(),
                                    color: statusColor.withValues(alpha: 0.12),
                                    textColor: statusColor,
                                    borderColor: statusColor.withValues(
                                      alpha: 0.24,
                                    ),
                                  ),
                                  _badge(
                                    text: _visibilityText(),
                                    color: visibilityColor.withValues(
                                      alpha: 0.12,
                                    ),
                                    textColor: visibilityColor,
                                    borderColor: visibilityColor.withValues(
                                      alpha: 0.22,
                                    ),
                                  ),
                                  if (widget.contest.isRated)
                                    _badge(
                                      text: 'Rated',
                                      color: Colors.indigo.shade100,
                                      textColor: Colors.indigo.shade700,
                                      borderColor: Colors.indigo.shade200,
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  // const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerHighest.withValues(
                        alpha: 0.4,
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.play_circle_outline_rounded,
                              size: 16,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Bắt đầu: ${_formatDateTime(widget.contest.startTime)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.flag_outlined,
                              size: 16,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Kết thúc: ${_formatDateTime(widget.contest.endTime)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 14),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      if (widget.isActiveContest)
                        _metaChip(
                          icon: Icons.verified_rounded,
                          text: 'Đang tham gia',
                          color: Colors.blue.shade700,
                          emphasized: true,
                        ),
                      ...widget.contest.tags
                          .take(2)
                          .map(
                            (tag) => _metaChip(
                              icon: Icons.sell_outlined,
                              text: tag,
                              color: scheme.primary,
                            ),
                          ),
                      if (widget.contest.tags.length > 2)
                        _metaChip(
                          icon: Icons.more_horiz_rounded,
                          text: '+${widget.contest.tags.length - 2}',
                          color: scheme.onSurfaceVariant,
                        ),
                    ],
                  ),
                  // const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: _metaChip(
                            icon: Icons.timelapse_rounded,
                            text: _durationText(),
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      if (actionButton != null) ...[
                        const SizedBox(width: 12),
                        actionButton,
                      ],
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    final h = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    return '$d/$m/$y $h:$min';
  }

  String _durationText() {
    final duration = widget.contest.endTime.difference(
      widget.contest.startTime,
    );
    final h = duration.inHours;
    final m = duration.inMinutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  String _visibilityText() {
    if (widget.contest.isOrganizationPrivate) return 'Organization';
    if (widget.contest.isPrivate) return 'Private';
    return 'Public';
  }

  Widget _metaChip({
    required IconData icon,
    required String text,
    required Color color,
    bool emphasized = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: emphasized
            ? color.withValues(alpha: 0.12)
            : color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge({
    required String text,
    required Color color,
    required Color textColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: borderColor ?? textColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _lockedButton(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.lock_outline_rounded,
            size: 16,
            color: Colors.orange.shade700,
          ),
          const SizedBox(width: 6),
          Text(
            "Mở sau ${formatTime(countdown)}",
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            Icons.schedule_rounded,
            size: 14,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
