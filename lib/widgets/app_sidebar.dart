import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SidebarItem {
  final String title;
  final IconData icon;
  final String route;

  const SidebarItem({
    required this.title,
    required this.icon,
    required this.route,
  });

  static const List<SidebarItem> items = [
    SidebarItem(title: "Trang chủ", icon: Icons.home, route: "/"),
    SidebarItem(title: "Bài tập", icon: Icons.code, route: "/problems"),
    SidebarItem(
      title: "Cuộc thi",
      icon: Icons.emoji_events,
      route: "/contests",
    ),
  ];
}

class AppSidebar extends ConsumerStatefulWidget {
  final List<SidebarItem> items;
  final String activeRoute;

  const AppSidebar({
    super.key,
    required this.activeRoute,
    this.items = SidebarItem.items,
  });

  @override
  ConsumerState<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends ConsumerState<AppSidebar> {
  bool isExpanded = false;
  String username = "";
  double expandedWidth = 252;
  double collapsedWidth = Layout.rem * 4.5;
  double get sidebarWidth => isExpanded ? expandedWidth : collapsedWidth;
  double get collapsedContentWidth => collapsedWidth - (Layout.spacing * 3);

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final tokenService = ref.read(tokenServiceProvider);
    final token = await tokenService.getValidAccessToken();
    if (!mounted || token == null) return;
    final username = tokenService.getUsername(token);
    setState(() {
      this.username = username;
    });
  }

  Future<void> _handleLogout() async {
    final authRepository = ref.read(authRepositoryProvider);
    await authRepository.logout();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 190),
      width: sidebarWidth,
      margin: const EdgeInsets.fromLTRB(
        Layout.spacing * 2,
        Layout.spacing * 2,
        Layout.spacing,
        Layout.spacing * 2,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            scheme.surfaceContainerLowest.withValues(alpha: 0.9),
            scheme.surfaceContainerLow.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(Layout.borderRadiusLg),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.85),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              Layout.spacing,
              Layout.spacing * 1.5,
              Layout.spacing,
              Layout.spacing * 1.5,
            ),
            child: _buildToggleButton(context),
          ),
          Divider(
            color: scheme.outlineVariant.withValues(alpha: 0.75),
            height: 1,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                Layout.spacing,
                Layout.spacing * 1.5,
                Layout.spacing,
                Layout.spacing,
              ),
              itemCount: widget.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, index) => _buildItem(widget.items[index]),
            ),
          ),
          Divider(
            color: scheme.outlineVariant.withValues(alpha: 0.75),
            height: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(Layout.spacing),
            child: _buildUserSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      height: collapsedContentWidth + (Layout.spacing * 2),
      child: Row(
        children: [
          SizedBox(
            width: collapsedContentWidth,
            height: collapsedContentWidth,
            child: IconButton(
              style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(collapsedContentWidth, collapsedContentWidth),
                backgroundColor: scheme.primaryContainer.withValues(alpha: 0.7),
                foregroundColor: scheme.onPrimaryContainer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
                  side: BorderSide(
                    color: scheme.primary.withValues(alpha: 0.22),
                  ),
                ),
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: Icon(
                  isExpanded
                      ? Icons.keyboard_double_arrow_left_rounded
                      : Icons.keyboard_double_arrow_right_rounded,
                  key: ValueKey(isExpanded),
                ),
              ),
            ),
          ),
          if (isExpanded)
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: Layout.spacing * 1.25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TMATH',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.7,
                        height: 1.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'workspace thi dau',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: 0.2,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionButton(
    IconData icon,
    Color color,
    String label,
    VoidCallback onTap, {
    Color? backgroundColor,
    bool active = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 140),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
        border: Border.all(
          color: active
              ? color.withValues(alpha: 0.28)
              : color.withValues(alpha: 0.08),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
          child: SizedBox(
            height: 44,
            child: Row(
              children: [
                SizedBox(
                  width: collapsedContentWidth,
                  child: Center(
                    child: Icon(icon, color: color, size: active ? 21 : 20),
                  ),
                ),
                if (isExpanded)
                  Flexible(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(SidebarItem item) {
    final scheme = Theme.of(context).colorScheme;
    final isActive =
        widget.activeRoute == item.route ||
        widget.activeRoute.startsWith('${item.route}/');

    return _actionButton(
      item.icon,
      isActive ? scheme.onPrimaryContainer : scheme.onSurfaceVariant,
      item.title,
      () => context.go(item.route),
      backgroundColor: isActive
          ? scheme.primaryContainer.withValues(alpha: 0.78)
          : scheme.surfaceContainerLowest.withValues(alpha: 0.52),
      active: isActive,
    );
  }

  Widget _buildUserSection(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: scheme.surfaceContainer.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(Layout.borderRadiusMd),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              SizedBox(
                width: collapsedContentWidth,
                child: CircleAvatar(
                  backgroundColor: scheme.primaryContainer,
                  foregroundColor: scheme.onPrimaryContainer,
                  child: const Icon(Icons.person_outline),
                ),
              ),
              if (isExpanded)
                Expanded(
                  child: Text(
                    username.isNotEmpty ? username : 'Người dùng',
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _actionButton(
          Icons.logout_rounded,
          scheme.error,
          'Đăng xuất',
          _handleLogout,
          backgroundColor: scheme.errorContainer.withValues(alpha: 0.48),
        ),
      ],
    );
  }
}
