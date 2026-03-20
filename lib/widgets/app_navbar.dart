import 'package:exam_client_flutter/constants/layout.dart';
import 'package:exam_client_flutter/widgets/app_container.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/di.dart';

class AppNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBack;

  const AppNavbar({super.key, required this.title, this.showBack = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: tokenStorage.getToken(),
      builder: (context, snapshot) {
        final token = snapshot.data;
        final username = tokenService.getUsername(token);

        return Container(
          height: 64,
          width: double.infinity,
          color: Colors.white,
          child: AppContainer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: Layout.text_2xl,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: Layout.spacing * 2.5),
                  margin: EdgeInsets.only(right: Layout.spacing * 2),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(
                      Layout.border_radius_4xl,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: Layout.spacing * 4),
                      const SizedBox(width: Layout.spacing * 2),
                      Text(username ?? "User"),
                      IconButton(
                        icon: const Icon(
                          Icons.logout,
                          size: Layout.spacing * 4,
                        ),
                        onPressed: () async {
                          await tokenStorage.clearToken();
                          if (!context.mounted) return;
                          context.go('/');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
