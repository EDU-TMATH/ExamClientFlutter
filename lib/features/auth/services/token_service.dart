import 'package:exam_client_flutter/features/auth/data/api/auth_api.dart';
import 'package:exam_client_flutter/features/auth/data/storage/token_storage.dart';
import 'package:exam_client_flutter/features/auth/models/token.dart';
import 'package:jwt_decode/jwt_decode.dart';

class TokenService {
  final TokenStorage storage;
  final AuthApi authApi;
  String? _cachedAccess;

  TokenService({required this.authApi, required this.storage});

  Future<String?> getValidAccessToken() async {
    if (_cachedAccess != null) return _cachedAccess;
    final token = await storage.get();
    if (token == null) return null;

    if (isExpired(token.access)) {
      final newToken = await authApi.refresh(token.refresh);
      await storage.save(newToken);
      _cachedAccess = newToken.access;
      return newToken.access;
    }

    _cachedAccess = token.access;
    return token.access;
  }

  Future<String?> refresh() async {
    final token = await storage.get();
    if (token == null) return null;

    final newToken = await authApi.refresh(token.refresh);
    await storage.save(newToken);
    _cachedAccess = newToken.access;
    return newToken.access;
  }

  Future<Token?> getToken() async {
    return await storage.get();
  }

  Future<void> save(Token token) async {
    await storage.save(token);
    _cachedAccess = token.access;
  }

  Future<void> clear() async {
    await storage.clear();
    _cachedAccess = null;
  }

  bool isExpired(String token) {
    return Jwt.isExpired(token);
  }

  DateTime getExpiry(String token) {
    return Jwt.getExpiryDate(token)!;
  }

  Map<String, dynamic> decode(String token) {
    return Jwt.parseJwt(token);
  }

  // ================= GET USERNAME =================
  String getUsername(String token) {
    final payload = decode(token);
    return payload['username'];
  }
}
