import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage _storage;

  static const String _token = 'token';
  static const String _refreshToken = 'refresh_token';
  static const String _rememberCredentials = 'remember_credentials';
  static const String _savedUsername = 'saved_username';
  static const String _savedPassword = 'saved_password';

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

  Future<void> clearToken() async {
    await _storage.delete(key: _token);
    await _storage.delete(key: _refreshToken);
  }

  // Remember credentials functionality
  Future<void> saveRememberCredentials(String username, String password) async {
    await _storage.write(key: _rememberCredentials, value: 'true');
    await _storage.write(key: _savedUsername, value: json.encode(username));
    await _storage.write(key: _savedPassword, value: json.encode(password));
  }

  Future<void> clearRememberCredentials() async {
    await _storage.delete(key: _rememberCredentials);
    await _storage.delete(key: _savedUsername);
    await _storage.delete(key: _savedPassword);
  }

  Future<bool> hasRememberCredentials() async {
    final remember = await _storage.read(key: _rememberCredentials);
    return remember == 'true';
  }

  Future<Map<String, String>?> getRememberCredentials() async {
    final hasRemember = await hasRememberCredentials();
    if (!hasRemember) return null;

    final usernameStr = await _storage.read(key: _savedUsername);
    final passwordStr = await _storage.read(key: _savedPassword);

    if (usernameStr != null && passwordStr != null) {
      final username = json.decode(usernameStr);
      final password = json.decode(passwordStr);
      return {'username': username, 'password': password};
    }

    return null;
  }
}
