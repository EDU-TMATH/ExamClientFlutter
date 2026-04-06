import 'package:exam_client_flutter/core/providers/app_providers.dart';
import 'package:exam_client_flutter/features/auth/screens/login_screen.dart';
import 'package:exam_client_flutter/features/contest/screens/contest_list.dart';
import 'package:exam_client_flutter/features/contest/screens/contest_detail.dart';
import 'package:exam_client_flutter/features/contest/screens/contest_problem_detail.dart';
import 'package:exam_client_flutter/features/contest/screens/contest_submit_screen.dart';
import 'package:exam_client_flutter/features/home/screens/home_screen.dart';
import 'package:exam_client_flutter/features/problem/screens/problem_detail_screen.dart';
import 'package:exam_client_flutter/features/problem/screens/problem_list_screen.dart';
import 'package:exam_client_flutter/features/problem/screens/problem_submit_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// String? authGuard(String path, String? token) {
//   final isLoggedIn = token != null && !tokenService.isExpired(token);
//   // print("Auth guard check: path=$path, isLoggedIn=$isLoggedIn");

//   if (!isLoggedIn && path != '/login') return '/login';
//   if (isLoggedIn && path == '/login') return '/';

//   return null;
// }

final router = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final container = ProviderScope.containerOf(context);
    final repo = container.read(authRepositoryProvider);

    final isLoggedIn = await repo.isLoggedIn();

    if (!isLoggedIn) return '/login';
    if (state.fullPath == '/login') return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
    GoRoute(
      path: '/problems',
      builder: (context, state) => const ProblemListScreen(),
    ),
    GoRoute(
      path: '/problems/:code',
      builder: (context, state) {
        final code = state.pathParameters['code']!;
        return ProblemDetailScreen(problemCode: code);
      },
    ),
    GoRoute(
      path: '/problems/:code/submit',
      builder: (context, state) {
        final code = state.pathParameters['code']!;
        return ProblemSubmitScreen(problemCode: code);
      },
    ),
    GoRoute(
      path: '/contests',
      builder: (context, state) => const ContestList(),
    ),
    GoRoute(
      path: '/contest/:key',
      builder: (context, state) {
        final key = state.pathParameters['key']!;
        return ContestDetail(contestKey: key);
      },
    ),
    GoRoute(
      path: '/contest/:key/:problem',
      builder: (context, state) {
        final key = state.pathParameters['key']!;
        final problem = state.pathParameters['problem']!;
        return ContestProblemDetailScreen(
          contestKey: key,
          problemCode: problem,
        );
      },
    ),
    GoRoute(
      path: '/contest/:key/:problem/submit',
      builder: (context, state) {
        final key = state.pathParameters['key']!;
        final problem = state.pathParameters['problem']!;
        return ContestSubmitScreen(contestKey: key, problemCode: problem);
      },
    ),
  ],
);
