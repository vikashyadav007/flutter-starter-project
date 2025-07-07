import 'package:fuel_pro_360/features/auth/domain/repositories/auth_repositories.dart';

class ClearTokenUseCase {
  AuthRepository repository;
  ClearTokenUseCase(this.repository);

  Future<void> execute() async {
    repository.clearAuthData();
  }
}
