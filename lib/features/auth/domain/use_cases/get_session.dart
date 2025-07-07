import 'package:fuel_pro_360/features/auth/domain/repositories/auth_repositories.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetSessionUseCase {
  final AuthRepository repository;

  GetSessionUseCase(this.repository);

  Future<Session?> execute() async {
    return await repository.getSession();
  }
}
