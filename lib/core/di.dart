import 'package:exam_client_flutter/features/auth/data/api/auth_api.dart';
import 'package:exam_client_flutter/features/auth/data/repositories/auth_repository.dart';
import 'package:exam_client_flutter/features/auth/data/storage/token_storage.dart';
import 'package:exam_client_flutter/features/auth/services/auth_service.dart';
import 'package:exam_client_flutter/features/auth/services/token_service.dart';
import 'package:exam_client_flutter/features/contest/services/contest_service.dart';

import 'network/dio_client.dart';

final dioClient = DioClient();
final authService = AuthService(dioClient.dio);
final tokenStorage = TokenStorage();
final authApi = AuthApi(dioClient.dio);
final tokenService = TokenService(authApi: authApi, storage: tokenStorage);
final contestService = ContestService(dioClient.dio);

final authRepository = AuthRepository(authApi, tokenService);
