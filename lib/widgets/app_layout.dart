import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/widgets/app_sidebar.dart';
import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String activeRoute;
  final Widget body;
  final Widget? headerAction;
  final String? breadcrumbLabel;
  final VoidCallback? onBreadcrumbTap;

  const AppLayout({
    super.key,
    required this.title,
    required this.activeRoute,
    required this.body,
    this.subtitle,
    this.headerAction,
    this.breadcrumbLabel,
    this.onBreadcrumbTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Row(
          children: [
            AppSidebar(activeRoute: activeRoute),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(Layout.spacing * 3),
                child: Column(
                  children: [
                    _AppHeader(
                      title: title,
                      subtitle: subtitle,
                      action: headerAction,
                      breadcrumbLabel: breadcrumbLabel,
                      onBreadcrumbTap: onBreadcrumbTap,
                    ),
                    const SizedBox(height: Layout.spacing * 3),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(
                            Layout.borderRadiusXl,
                          ),
                          border: Border.all(color: scheme.outlineVariant),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: body,
                      ),
                    ),
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
  final String? breadcrumbLabel;
  final VoidCallback? onBreadcrumbTap;

  const _AppHeader({
    required this.title,
    this.subtitle,
    this.action,
    this.breadcrumbLabel,
    this.onBreadcrumbTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: Layout.spacing * 4,
        vertical: Layout.spacing * 3,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(Layout.borderRadiusXl),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (breadcrumbLabel != null && onBreadcrumbTap != null) ...[
                  InkWell(
                    onTap: onBreadcrumbTap,
                    borderRadius: BorderRadius.circular(Layout.borderRadiusSm),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: Layout.spacing,
                        horizontal: Layout.spacing * 1.5,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chevron_left,
                            size: 18,
                            color: scheme.primary,
                          ),
                          Text(
                            breadcrumbLabel!,
                            style: textTheme.labelLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Layout.spacing * 1.5),
                ],
                Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: Layout.spacing * 1.5),
                  Text(
                    subtitle!,
                    style: textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
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
