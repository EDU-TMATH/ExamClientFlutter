import 'package:exam_client_flutter/features/auth/models/token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  Future<void> save(Token token) async {
    await _storage.write(key: _accessKey, value: token.access);
    await _storage.write(key: _refreshKey, value: token.refresh);
  }

  Future<Token?> get() async {
    final access = await _storage.read(key: _accessKey);
    final refresh = await _storage.read(key: _refreshKey);
    if (access != null && refresh != null) {
      return Token(access: access, refresh: refresh);
    }
    return null;
  }

  Future<void> clear() async {
    await _storage.delete(key: _accessKey);
    await _storage.delete(key: _refreshKey);
  }
}
