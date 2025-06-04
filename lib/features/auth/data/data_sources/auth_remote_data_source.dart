import 'package:starter_project/core/api/api_client.dart';
import 'package:starter_project/features/auth/data/models/login_response/login_response_model.dart';

class AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSource(this._apiClient);

  Future<String> getUserApiUrl() async {
    return await _apiClient.getLoginUrl();
  }

  Future<LoginResponseModel> login(String username, String password) async {
    final response = await _apiClient.login({
      'email': username,
      'password': password,
    });

    return response;
  }
}
