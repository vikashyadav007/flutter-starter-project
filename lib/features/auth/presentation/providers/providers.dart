import 'package:fuel_pro_360/core/api/api_provider.dart';
import 'package:fuel_pro_360/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:fuel_pro_360/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:fuel_pro_360/features/auth/data/repositories/auth_repositories_impl.dart';
import 'package:fuel_pro_360/features/auth/domain/repositories/auth_repositories.dart';
import 'package:fuel_pro_360/features/auth/domain/use_cases/clear_token_use_case.dart';
import 'package:fuel_pro_360/features/auth/domain/use_cases/get_session.dart';
import 'package:fuel_pro_360/features/auth/domain/use_cases/login_use_case.dart';
import 'package:fuel_pro_360/features/auth/domain/use_cases/save_auth_data_use_case.dart';
import 'package:fuel_pro_360/features/auth/domain/use_cases/save_token_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSource(const FlutterSecureStorage());
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final authRemoteDataSource = AuthRemoteDataSource(apiClient);
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);

  return AuthRepositoriesImpl(authRemoteDataSource, authLocalDataSource);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
});

final getSessionUseCaseProvider = Provider<GetSessionUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetSessionUseCase(repository);
});

final saveAuthDataUseCaseProvider = Provider<SaveAuthDataUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SaveAuthDataUseCase(repository);
});

final clearTokenUseCaseProvider = Provider<ClearTokenUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);

  return ClearTokenUseCase(repository);
});

final saveTokenUseCaseProvider = Provider<SaveTokenUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SaveTokenUseCase(repository: repository);
});
