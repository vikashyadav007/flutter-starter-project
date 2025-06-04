import 'package:starter_project/features/auth/domain/entity/login_response_entity.dart';
import 'package:starter_project/features/auth/domain/repositories/auth_repositories.dart';

class SaveAuthDataUseCase {
  final AuthRepository repository;

  SaveAuthDataUseCase(this.repository);

  Future<void> execute(LoginResponseEntity loginEntity) async {
    return await repository.saveAuthData(loginEntity);
  }
}
