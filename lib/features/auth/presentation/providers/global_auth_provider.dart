import 'package:starter_project/features/auth/domain/entity/auth_entity.dart';
import 'package:starter_project/features/auth/domain/entity/login_response_entity.dart';
import 'package:starter_project/features/auth/domain/entity/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'global_auth_provider.g.dart';

@Riverpod(keepAlive: true)
class GlobalAuth extends _$GlobalAuth {
  @override
  AuthEntity build() {
    return const AuthEntity();
  }

  void setUser(UserEntity user) {
    state = state.copyWith(user: user, isAuthenticated: true);
  }

  void setToken(LoginResponseEntity loginResponse) {
    state = state.copyWith(loginResponse: loginResponse, isAuthenticated: true);
  }

  void clearAuth() {
    state = const AuthEntity();
  }
}
