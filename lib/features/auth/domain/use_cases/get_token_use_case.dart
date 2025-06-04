import 'package:starter_project/features/auth/domain/entity/login_response_entity.dart';
import 'package:starter_project/features/auth/domain/repositories/auth_repositories.dart';

class GetTokenUseCase {
  final AuthRepository repository;

  GetTokenUseCase(this.repository);

  Future<LoginResponseEntity?> execute() async {
    return await repository.getAllToken();
  }
}
