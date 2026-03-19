import 'storage/token_storage.dart';
import 'api/api_client.dart';
import '../features/auth/services/auth_service.dart';
import '../features/auth/services/token_service.dart';

final apiClient = ApiClient();
final authService = AuthService(apiClient.dio);
final tokenStorage = TokenStorage();
final tokenService = TokenService();
