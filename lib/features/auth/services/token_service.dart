import 'dart:convert';

import 'package:exam_client_flutter/features/auth/models/user.dart';

class TokenService {
  // static const _key = 'access_token';

  // // ================= SAVE =================
  // Future<void> saveToken(String token) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_key, token);
  // }

  // // ================= GET =================
  // Future<String?> getToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_key);
  // }

  // // ================= CLEAR =================
  // Future<void> clearToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.remove(_key);
  // }

  // ================= DECODE =================
  UserPayload? parseJwt(String? token) {
    if (token == null || token.isEmpty) return null;

    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];

      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));
      print("Decoded JWT payload: $decoded");

      final Map<String, dynamic> json = jsonDecode(decoded);
      print("Parsed JWT payload: $json");
      // 👇 optional: validate field
      if (!json.containsKey('exp')) return null;
      print("Successfully parsed JWT payload with exp: ${json['exp']}");
      print("UserPayload.fromJson output: ${UserPayload.fromJson(json)}");
      return UserPayload.fromJson(json);
    } catch (e, stack) {
      print("JWT ERROR: $e");
      print(stack);
      return null;
    }
  }

  // ================= CHECK EXPIRED =================
  bool isExpired(String? token) {
    final payload = parseJwt(token);
    print("Checking token expiration: payload=$payload");
    if (payload == null) return true;
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final isExpired = payload.exp < now;
    print(
      "Token expiration check: now=$now, exp=${payload.exp}, isExpired=$isExpired",
    );
    return isExpired;
  }

  // ================= GET USERNAME =================
  String? getUsername(String? token) {
    final payload = parseJwt(token);
    if (payload == null) return null;
    return payload.username;
  }
}
