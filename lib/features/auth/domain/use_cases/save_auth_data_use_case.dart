import 'package:fuel_pro_360/features/auth/domain/repositories/auth_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SaveAuthDataUseCase {
  final AuthRepository repository;

  SaveAuthDataUseCase(this.repository);

  Future<void> execute(AuthResponse authResponse) async {
    return await repository.saveAuthData(authResponse);
  }
}
