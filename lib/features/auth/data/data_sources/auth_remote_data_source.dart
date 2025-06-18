import 'package:starter_project/core/api/api_client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<String> getUserApiUrl() async {
    return await _apiClient.getLoginUrl();
  }

  Future<AuthResponse> login(String username, String password) async {
    AuthResponse authResponse;
    try {
      authResponse = await Supabase.instance.client.auth.signInWithPassword(
        email: username,
        password: password,
      );
      print("result is ${authResponse.session?.accessToken}");
    } catch (e) {
      print("Error during login: $e");
      // Handle the error appropriately, maybe throw a custom exception
      throw Exception("Login failed: $e");
    }

    return authResponse;
  }

  Future<Session?> getSession() async {
    Session? session;
    try {
      session = Supabase.instance.client.auth.currentSession;
    } catch (e) {
      print(e);
    }

    return session;
  }

  Future<Session?> logout() async {
    Session? session;
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e) {
      print(e);
    }

    return session;
  }
}
