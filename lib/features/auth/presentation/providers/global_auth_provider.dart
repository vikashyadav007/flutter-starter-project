import 'package:starter_project/features/auth/domain/entity/auth_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'global_auth_provider.g.dart';

@Riverpod(keepAlive: true)
class GlobalAuth extends _$GlobalAuth {
  @override
  AuthEntity build() {
    return const AuthEntity();
  }

  void setToken(Session session) {
    state = state.copyWith(session: session, isAuthenticated: true);
  }

  void clearAuth() {
    state = const AuthEntity();
  }
}
