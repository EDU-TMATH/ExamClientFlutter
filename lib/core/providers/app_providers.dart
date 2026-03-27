import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:exam_client_flutter/core/network/dio_client.dart';

import 'package:exam_client_flutter/features/auth/data/api/auth_api.dart';
import 'package:exam_client_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:exam_client_flutter/features/auth/data/storage/token_storage.dart';
import 'package:exam_client_flutter/features/auth/services/token_service.dart';
import 'package:exam_client_flutter/features/contest/services/contest_service.dart';

/// 🔹 Dio
final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

final dioProvider = Provider((ref) {
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

final contestServiceProvider = Provider<ContestService>((ref) {
  return ContestService(ref.read(dioProvider));
});

/// 🔹 Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.read(authApiProvider),
    ref.read(tokenServiceProvider),
  );
});
