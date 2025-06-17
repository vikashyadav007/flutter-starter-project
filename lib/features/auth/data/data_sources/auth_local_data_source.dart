import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  static const String _token = 'token';
  static const String _refreshToken = 'refresh_token';

  AuthLocalDataSource(this._storage);

  Future<void> cacheToken(String token) async {
    await _storage.write(key: _token, value: json.encode(token));
  }

  Future<void> cacheRefreshToken(String token) async {
    await _storage.write(key: _refreshToken, value: json.encode(token));
  }

  Future<void> cache(String token, String refreshToken) async {
    await cacheToken(token);
    await cacheRefreshToken(refreshToken);
  }

  Future<String?> getToken() async {
    final tokenStr = await _storage.read(key: _token);
    if (tokenStr == null) return null;

    final token = json.decode(tokenStr);

    return token;
  }

  Future<String?> getRefreshToken() async {
    final tokenStr = await _storage.read(key: _refreshToken);
    if (tokenStr == null) return null;

    final token = json.decode(tokenStr);

    return token;
  }

  Future<AuthResponse?> getAll() async {
    final tokenStr = await _storage.read(key: _token);
    final refreshTokenStr = await _storage.read(key: _refreshToken);
    if (tokenStr != null && refreshTokenStr != null) {
      final token = json.decode(tokenStr);
      final refreshToken = json.decode(refreshTokenStr);

      return AuthResponse();
    }

    return null;
  }

  Future<void> clear() async {
    await _storage.delete(key: _token);
    await _storage.delete(key: _refreshToken);
  }
}
