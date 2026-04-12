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
                padding: const EdgeInsets.fromLTRB(
                  Layout.spacing,
                  Layout.spacing * 2,
                  Layout.spacing * 2,
                  Layout.spacing * 2,
                ),
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
                          borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
                          border: Border.all(color: scheme.outlineVariant),
                          boxShadow: [
                            BoxShadow(
                              color: scheme.shadow.withValues(alpha: 0.04),
                              blurRadius: 16,
                              offset: const Offset(0, 8),
                            ),
                          ],
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
        horizontal: Layout.spacing * 3,
        vertical: Layout.spacing * 2.5,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
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
                            Icons.arrow_back_ios_new_rounded,
                            size: 14,
                            color: scheme.primary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            breadcrumbLabel!,
                            style: textTheme.labelLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.35,
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
                    letterSpacing: -0.3,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: Layout.spacing),
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
