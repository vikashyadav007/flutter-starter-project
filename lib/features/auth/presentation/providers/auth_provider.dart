import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/features/auth/domain/use_cases/clear_token_use_case.dart';
import 'package:fuel_pro_360/features/auth/domain/use_cases/get_session.dart';
import 'package:fuel_pro_360/features/auth/domain/use_cases/login_use_case.dart';
import 'package:fuel_pro_360/features/auth/domain/use_cases/save_auth_data_use_case.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/auth_error_mapper.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/global_auth_provider.dart';
import 'package:fuel_pro_360/features/auth/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/providers/auth_credential_provider.dart';
import 'package:fuel_pro_360/shared/utils/handle_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loggingIn() = _LoggingIn;
  const factory AuthState.checkingSavedAuth() = _CheckingSavedAuth;
  const factory AuthState.loggedIn(Session session) = _LoggedIn;
  const factory AuthState.fetchingProfile() = _FetchingProfile;

  //TODO add here user profile
  const factory AuthState.completed(Session session) = _Completed;
  const factory AuthState.error(Failure error) = _Error;
  const factory AuthState.loggingOut() = _LoggingOut;
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // final LoginUseCase = ref.watch(loginUserCas);
  final authCredentialNotifier = ref.watch(authCredentialProvider.notifier);
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final getSessionUseCase = ref.watch(getSessionUseCaseProvider);
  final saveAuthDataUseCase = ref.watch(saveAuthDataUseCaseProvider);
  final globalAuth = ref.watch(globalAuthProvider.notifier);
  final clearTokenUseCase = ref.watch(clearTokenUseCaseProvider);

  final router = ref.watch(routerProvider);

  return AuthNotifier(
    loginUseCase: loginUseCase,
    authCredentialNotifier: authCredentialNotifier,
    globalAuth: globalAuth,
    getSessionUseCase: getSessionUseCase,
    saveAuthDataUseCase: saveAuthDataUseCase,
    clearTokenUseCase: clearTokenUseCase,
    router: router,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final GetSessionUseCase getSessionUseCase;
  final SaveAuthDataUseCase saveAuthDataUseCase;
  final AuthCredentialNotifier authCredentialNotifier;
  final GlobalAuth globalAuth;
  final ClearTokenUseCase clearTokenUseCase;
  final GoRouter router;
  AuthNotifier({
    required this.loginUseCase,
    required this.authCredentialNotifier,
    required this.globalAuth,
    required this.getSessionUseCase,
    required this.saveAuthDataUseCase,
    required this.clearTokenUseCase,
    required this.router,
  }) : super(const AuthState.initial()) {
    _checkSavedAuth();
  }

  Future<void> _checkSavedAuth() async {
    state = const AuthState.checkingSavedAuth();
    Session? session = await getSessionUseCase.execute();

    if (session != null) {
      globalAuth.setToken(session);
      state = AuthState.completed(session);
      authCredentialNotifier.setCredentials(session?.accessToken ?? "");
      router.goNamed(AppPath.home.name);
    } else {
      state = const AuthState.initial();
    }
  }

  Future<bool> login(String username, String password) async {
    state = const AuthState.loggingIn();
    bool status = false;

    try {
      final loginResult = await loginUseCase.execute(username, password);

      late AuthResponse authResponse;

      state = loginResult.fold(
        (failure) {
          return AuthState.error(mapLoginFailure(failure));
        },
        (response) {
          authResponse = response;
          if (authResponse.session != null) {
            saveAuthDataUseCase.execute(authResponse);
            globalAuth.setToken(authResponse.session!);
            authCredentialNotifier
                .setCredentials(authResponse.session?.accessToken ?? '');
            status = true;
            return AuthState.loggedIn(authResponse.session!);
          }

          return AuthState.error(
            handleException(
              exception: Exception("Login failed, no session returned."),
              message: "Login failed, please try again.",
            ),
          );
        },
      );

      // state = AuthState.completed(authResponse.session!);

      //Todo user profile fetching
    } catch (e) {}

    return status;
  }

  Future<void> logout() async {
    try {
      state = const AuthState.loggingOut();
      await clearTokenUseCase.execute();
      authCredentialNotifier.clearCredentials();
      globalAuth.clearAuth();

      state = const AuthState.initial();
    } catch (e) {
      state = AuthState.error(
        handleException(
          exception: e,
          message: "Failed to logout, please try again later.",
        ),
      );
    }
  }
}
