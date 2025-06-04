import 'package:starter_project/features/auth/domain/repositories/auth_repositories.dart';

class ClearTokenUseCase {
  AuthRepository repository;
  ClearTokenUseCase(this.repository);

  Future<void> execute() async {
    repository.clearAuthData();
  }
}
