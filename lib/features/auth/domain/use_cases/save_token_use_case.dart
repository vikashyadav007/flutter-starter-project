import 'package:fuel_pro_360/features/auth/domain/repositories/auth_repositories.dart';

class SaveTokenUseCase {
  final AuthRepository _repository;

  SaveTokenUseCase({required repository}) : _repository = repository;

  Future<void> execute({required String token}) async {
    return _repository.saveAccessToken(token);
  }
}
