import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final List<Widget> actions;

  const AppTopBar({
    super.key,
    required this.title,
    this.onBack,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Layout.spacing * 3,
        vertical: Layout.spacing * 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: slate.shade(200))),
      ),
      child: Row(
        children: [
          if (onBack != null) ...[
            IconButton(
              tooltip: 'Quay lại',
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            ),
            const SizedBox(width: Layout.spacing),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: Layout.textLg,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}
