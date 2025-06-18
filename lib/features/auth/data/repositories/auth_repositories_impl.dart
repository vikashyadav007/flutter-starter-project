import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/error_handler.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:starter_project/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:starter_project/features/auth/domain/entity/user_entity.dart';
import 'package:starter_project/features/auth/domain/repositories/auth_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepositoriesImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoriesImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<void> clearAuthData() async {
    await _remoteDataSource.logout();
    await _localDataSource.clear();
  }

  @override
  Future<String?> getAccessToken() {
    // TODO: implement getAccessToken
    throw UnimplementedError();
  }

  @override
  Future<String?> getRefreshToken() {
    // TODO: implement getRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> getUserApiUrl() {
    // TODO: implement getUserApiUrl
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, UserEntity>> getUserProfile() {
    // TODO: implement getUserProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AuthResponse>> login(
    String username,
    String password,
  ) async {
    try {
      final authResponse = await _remoteDataSource.login(username, password);
      return Right(authResponse);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<void> saveAuthData(AuthResponse authResponse) async {
    await _localDataSource.cache(authResponse.session?.accessToken ?? "",
        authResponse.session?.refreshToken ?? "");
  }

  @override
  Future<Session?> getSession() async {
    return await _remoteDataSource.getSession();
  }

  @override
  Future<void> saveAccessToken(String token) async {
    return await _localDataSource.cacheToken(token);
  }
}
