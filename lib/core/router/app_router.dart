import 'package:exam_client_flutter/core/di.dart';
import 'package:exam_client_flutter/features/auth/screens/login_screen.dart';
import 'package:exam_client_flutter/features/contest/screens/contest_list.dart';
import 'package:go_router/go_router.dart';

String? authGuard(String path, String? token) {
  final isLoggedIn = token != null && !tokenService.isExpired(token);
  print("Auth guard check: path=$path, isLoggedIn=$isLoggedIn");

  if (!isLoggedIn && path != '/login') return '/login';
  if (isLoggedIn && path == '/login') return '/contests';

  return null;
}

final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final token = await tokenStorage.getToken();
    print("Checking auth for path: ${state.fullPath}, token: $token");
    return authGuard(state.fullPath ?? '', token);
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/contests',
      builder: (context, state) => const ContestList(),
    ),
  ],
);
