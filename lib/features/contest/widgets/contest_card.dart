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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // LEFT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contest.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),

                  _buildStatus(),

                  if (widget.isActiveContest) ...[
                    const SizedBox(height: 8),
                    _badge(
                      text: "Cuộc thi đang tham gia",
                      color: Colors.blue.shade50,
                      textColor: Colors.blue,
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(width: 12),

            // RIGHT
            if (widget.showAction)
              label == "start"
                  ? _lockedButton()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        widget.onJoin?.call(widget.contest.key);
                      },
                      child: Text(widget.actionLabel),
                    ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus() {
    if (label == "start") {
      return _badge(
        text: "Bắt đầu sau ${formatTime(countdown)}",
        color: Colors.orange.shade50,
        textColor: Colors.orange,
      );
    } else if (label == "end") {
      return _badge(
        text: "Kết thúc sau ${formatTime(countdown)}",
        color: Colors.green.shade50,
        textColor: Colors.green,
      );
    } else {
      return _badge(
        text: "Đã kết thúc",
        color: Colors.grey.shade200,
        textColor: Colors.grey,
      );
    }
  }

  Widget _badge({
    required String text,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, color: textColor)),
    );
  }

  Widget _lockedButton() {
    return Row(
      children: [
        const Icon(Icons.lock, size: 16),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.orange.shade200),
          ),
          child: Text(
            "Mở sau ${formatTime(countdown)}",
            style: TextStyle(
              color: Colors.orange.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
