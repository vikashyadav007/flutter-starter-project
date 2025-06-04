import 'package:dartz/dartz.dart';

import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/auth/domain/entity/login_response_entity.dart';
import 'package:starter_project/features/auth/domain/entity/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> getUserApiUrl();
  Future<Either<Failure, LoginResponseEntity>> login(
    String username,
    String password,
  );
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<void> saveAuthData(LoginResponseEntity loginEntity);
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<LoginResponseEntity?> getAllToken();
  Future<void> clearAuthData();
}
