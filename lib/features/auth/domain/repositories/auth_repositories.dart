import 'package:dartz/dartz.dart';

import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/auth/domain/entity/user_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRepository {
  Future<Either<Failure, String>> getUserApiUrl();
  Future<Either<Failure, AuthResponse>> login(
    String username,
    String password,
  );
  Future<Either<Failure, UserEntity>> getUserProfile();
  Future<void> saveAuthData(AuthResponse authResponse);
  Future<void> saveAccessToken(String token);
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<Session?> getSession();
  Future<void> clearAuthData();
}
