import 'package:exam_client_flutter/features/auth/services/auth_service.dart';
import 'package:exam_client_flutter/features/auth/services/token_service.dart';
import 'package:exam_client_flutter/features/contest/services/contest_service.dart';

import 'storage/token_storage.dart';
import 'api/api_client.dart';

final apiClient = ApiClient();
final authService = AuthService(apiClient.dio);
final tokenStorage = TokenStorage();
final tokenService = TokenService();
final contestService = ContestService(apiClient.dio);
