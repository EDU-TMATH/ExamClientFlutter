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
    final scheme = Theme.of(context).colorScheme;
    final statusColor = _statusColor(context);
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
                      horizontal: 14,
                      vertical: 10,
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
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.86),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 420;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isCompact) ...[
                    Text(
                      widget.contest.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: scheme.onSurface,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _badge(
                      text: _statusText(),
                      color: statusColor.withValues(alpha: 0.12),
                      textColor: statusColor,
                      borderColor: statusColor.withValues(alpha: 0.24),
                    ),
                    if (actionButton != null) ...[
                      const SizedBox(height: 10),
                      actionButton,
                    ],
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
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w800,
                                  color: scheme.onSurface,
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 8),
                              _badge(
                                text: _statusText(),
                                color: statusColor.withValues(alpha: 0.12),
                                textColor: statusColor,
                                borderColor: statusColor.withValues(
                                  alpha: 0.24,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (actionButton != null) actionButton,
                      ],
                    ),
                  const SizedBox(height: 14),
                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          _metaChip(
                            icon: Icons.key_rounded,
                            text: widget.contest.key,
                            color: scheme.onSurfaceVariant,
                          ),
                          _metaChip(
                            icon: Icons.schedule_rounded,
                            text:
                                '${_formatDateTime(widget.contest.startTime)} - ${_formatDateTime(widget.contest.endTime)}',
                            color: scheme.onSurfaceVariant,
                          ),
                          if (widget.isActiveContest)
                            _metaChip(
                              icon: Icons.verified_rounded,
                              text: 'Đang tham gia',
                              color: Colors.blue.shade700,
                              emphasized: true,
                            ),
                        ],
                      ),
                    ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
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
        ],
      ),
    );
  }
}
