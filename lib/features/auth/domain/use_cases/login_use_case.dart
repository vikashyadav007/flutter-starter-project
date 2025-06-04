import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/auth/domain/entity/login_response_entity.dart';
import 'package:starter_project/features/auth/domain/repositories/auth_repositories.dart';

class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  Future<Either<Failure, LoginResponseEntity>> execute(
    String username,
    String password,
  ) async {
    return await _authRepository.login(username, password);
  }
}
