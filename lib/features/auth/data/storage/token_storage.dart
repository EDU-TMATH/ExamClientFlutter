import 'package:exam_client_flutter/features/auth/models/token.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  final _storage = const FlutterSecureStorage();

  static const _accessKey = 'access_token';
  static const _refreshKey = 'refresh_token';

  bool _useFallbackStorage = false;

  Future<void> _saveFallback(Token token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessKey, token.access);
    await prefs.setString(_refreshKey, token.refresh);
  }

  Future<Token?> _getFallback() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString(_accessKey);
    final refresh = prefs.getString(_refreshKey);
    if (access == null || refresh == null) {
      return null;
    }
    return Token(access: access, refresh: refresh);
  }

  Future<void> _clearFallback() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_refreshKey);
  }

  bool _isSecureStorageUnavailable(Object e) {
    if (e is! PlatformException) return false;
    final msg = (e.message ?? '').toLowerCase();
    return e.code.contains('-34018') || msg.contains('-34018');
  }

  Future<void> save(Token token) async {
    if (_useFallbackStorage) {
      await _saveFallback(token);
      return;
    }

    try {
      await _storage.write(key: _accessKey, value: token.access);
      await _storage.write(key: _refreshKey, value: token.refresh);
    } catch (e) {
      if (!_isSecureStorageUnavailable(e)) rethrow;
      _useFallbackStorage = true;
      await _saveFallback(token);
    }
  }

  Future<Token?> get() async {
    if (_useFallbackStorage) {
      return _getFallback();
    }

    try {
      final access = await _storage.read(key: _accessKey);
      final refresh = await _storage.read(key: _refreshKey);
      if (access != null && refresh != null) {
        return Token(access: access, refresh: refresh);
      }
      return null;
    } catch (e) {
      if (!_isSecureStorageUnavailable(e)) rethrow;
      _useFallbackStorage = true;
      return _getFallback();
    }
  }

  Future<void> clear() async {
    if (_useFallbackStorage) {
      await _clearFallback();
      return;
    }

    try {
      await _storage.delete(key: _accessKey);
      await _storage.delete(key: _refreshKey);
    } catch (e) {
      if (!_isSecureStorageUnavailable(e)) rethrow;
      _useFallbackStorage = true;
      await _clearFallback();
    }
  }
}
