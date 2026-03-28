import 'package:exam_client_flutter/constants/app_color.dart';
import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/widgets/app_sidebar.dart';
import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String activeRoute;
  final Widget body;
  final Widget? headerAction;

  const AppLayout({
    super.key,
    required this.title,
    required this.activeRoute,
    required this.body,
    this.subtitle,
    this.headerAction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray.shade(100),
      body: SafeArea(
        child: Row(
          children: [
            AppSidebar(activeRoute: activeRoute),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Layout.spacing * 4),
                child: Column(
                  children: [
                    _AppHeader(
                      title: title,
                      subtitle: subtitle,
                      action: headerAction,
                    ),
                    const SizedBox(height: Layout.spacing * 4),
                    Expanded(child: body),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const _AppHeader({required this.title, this.subtitle, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Layout.spacing * 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, sky.shade(50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Layout.border_radius_2xl),
        border: Border.all(color: Colors.white70),
        boxShadow: [
          BoxShadow(
            color: slate.shade(900).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: Layout.text_2xl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: Layout.spacing * 1.5),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: slate.shade(600),
                      fontSize: Layout.text_sm,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (action != null) ...[
            const SizedBox(width: Layout.spacing * 3),
            action!,
          ],
        ],
      ),
    );
  }
}
