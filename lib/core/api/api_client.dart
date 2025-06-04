import 'package:dio/dio.dart';
import 'package:starter_project/features/auth/data/models/login_response/login_response_model.dart';
import 'package:starter_project/features/auth/data/models/refresh_response/refresh_response_model.dart';
import 'package:starter_project/shared/constants/api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) = _ApiClient;

  @GET(ApiConstants.loginApiUrl)
  Future<String> getLoginUrl();

  @POST(ApiConstants.login)
  Future<LoginResponseModel> login(@Body() Map<String, dynamic> body);

  @POST(ApiConstants.refreshToken)
  Future<RefreshResponseModel> refreshToken(@Body() Map<String, dynamic> body);
}
