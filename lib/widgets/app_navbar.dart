import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/di.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  const AppNavbar({super.key, required this.title, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,

      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            )
          : null,

      title: Text(
        title.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),

      actions: [
        FutureBuilder(
          future: tokenStorage.getToken(),
          builder: (context, snapshot) {
            final token = snapshot.data;
            final username = tokenService.getUsername(token);

            return Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 16),
                      const SizedBox(width: 6),
                      Text(username ?? "User"),
                    ],
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await tokenStorage.clearToken();
                    if (!context.mounted) return;
                    context.go('/');
                  },
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
