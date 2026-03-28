import 'package:exam_client_flutter/constants/app_color.dart';
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
    SidebarItem(
      title: "Bài tập",
      icon: Icons.library_books,
      route: "/problems",
    ),
    SidebarItem(
      title: "Cuộc thi",
      icon: Icons.emoji_events,
      route: "/contests",
    ),
    SidebarItem(
      title: "Bảng xếp hạng",
      icon: Icons.leaderboard,
      route: "/users",
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
  bool isExpanded = true;
  String username = "";
  double expandedWidth = 240;
  double collapsedWidth = Layout.rem * 4.5;
  double get sidebarWidth => isExpanded ? expandedWidth : collapsedWidth;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final tokenService = ref.read(tokenServiceProvider);
    final token = await tokenService.getValidAccessToken();
    final username = tokenService.getUsername(token!);
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
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: sidebarWidth,
      color: Colors.grey.shade900,
      child: Column(
        children: [
          _buildToggleButton(),
          const Divider(color: Colors.white24),
          // Top menu
          Expanded(
            child: ListView.separated(
              itemCount: widget.items.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: Layout.spacing * 2),
              itemBuilder: (context, index) => _buildItem(widget.items[index]),
            ),
          ),

          // Bottom user + logout
          const Divider(color: Colors.white24),
          _buildUserSection(),
        ],
      ),
    );
  }

  Widget _buildToggleButton() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: collapsedWidth,
          height: collapsedWidth,
          child: AnimatedRotation(
            turns: isExpanded ? 0.5 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              icon: CircleAvatar(
                backgroundColor: isExpanded ? Colors.blue : Colors.white54,
                child: Icon(Icons.gamepad),
              ),
              onPressed: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            ),
          ),
        ),
        if (isExpanded)
          Flexible(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EXAM CLIENT",
                  style: TextStyle(
                    color: sky.shade(600),
                    fontSize: Layout.text_xl,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
                Text(
                  "v1.0.0",
                  style: TextStyle(
                    color: slate.shade(400),
                    fontSize: Layout.text_xs,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _actionButton(
    IconData icon,
    Color color,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            SizedBox(
              width: collapsedWidth,
              child: Center(child: Icon(icon, color: color)),
            ),

            if (isExpanded)
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(color: color),
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(SidebarItem item) {
    final isActive =
        widget.activeRoute == item.route ||
        widget.activeRoute.startsWith('${item.route}/');

    return _actionButton(
      item.icon,
      isActive ? Colors.blue : Colors.white54,
      item.title,
      () => context.go(item.route),
    );
  }

  Widget _buildUserSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                SizedBox(
                  width: collapsedWidth,
                  child: CircleAvatar(
                    // radius: Layout.border_radius_2xl,
                    child: Icon(Icons.person),
                  ),
                ),
                if (isExpanded)
                  Flexible(
                    child: Text(
                      username.isNotEmpty ? username : "User",
                      style: const TextStyle(color: Colors.white),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _actionButton(
            Icons.logout,
            Colors.redAccent,
            "Logout",
            _handleLogout,
          ),
        ],
      ),
    );
  }
}
