import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:exam_client_flutter/core/network/dio_client.dart';
import 'package:exam_client_flutter/core/network/interceptors/auth_interceptor.dart';

import 'package:exam_client_flutter/features/auth/data/api/auth_api.dart';
import 'package:exam_client_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:exam_client_flutter/features/auth/data/storage/token_storage.dart';
import 'package:exam_client_flutter/features/auth/services/token_service.dart';
import 'package:exam_client_flutter/features/contest/services/contest_service.dart';
import 'package:exam_client_flutter/features/home/services/home_service.dart';
import 'package:exam_client_flutter/features/problem/data/api/problem_api.dart';
import 'package:exam_client_flutter/features/problem/data/repositories/problem_repository.dart';

/// 🔹 Dio
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

/// Raw Dio for unauthenticated endpoints (login/refresh/logout).
final dioProvider = Provider<Dio>((ref) {
  return ref.read(dioClientProvider).dio;
});

/// 🔹 Storage
final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

/// 🔹 API
final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(dioProvider));
});

/// 🔹 Services
final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService(
    authApi: ref.read(authApiProvider),
    storage: ref.read(tokenStorageProvider),
  );
});

/// Dio with auth interceptor for protected APIs.
final authDioProvider = Provider<Dio>((ref) {
  final dio = DioClient().dio;
  dio.interceptors.add(
    AuthInterceptor(ref.read(tokenServiceProvider), retryDio: DioClient().dio),
  );
  return dio;
});

final contestServiceProvider = Provider<ContestService>((ref) {
  return ContestService(ref.read(authDioProvider));
});

final problemApiProvider = Provider<ProblemApi>((ref) {
  return ProblemApi(ref.read(authDioProvider));
});

final problemRepositoryProvider = Provider<ProblemRepository>((ref) {
  return ProblemRepository(ref.read(problemApiProvider));
});

final homeServiceProvider = Provider<HomeService>((ref) {
  return HomeService(ref.read(authDioProvider));
});

/// 🔹 Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(authApiProvider),
    ref.read(tokenServiceProvider),
  );
});

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.system;
  }

  void toggleLightDark() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}
