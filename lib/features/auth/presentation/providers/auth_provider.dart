import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/features/auth/data/data_sources/auth_local_data_source.dart';
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
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);

  final router = ref.watch(routerProvider);

  return AuthNotifier(
    loginUseCase: loginUseCase,
    authCredentialNotifier: authCredentialNotifier,
    globalAuth: globalAuth,
    getSessionUseCase: getSessionUseCase,
    saveAuthDataUseCase: saveAuthDataUseCase,
    clearTokenUseCase: clearTokenUseCase,
    authLocalDataSource: authLocalDataSource,
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
  final AuthLocalDataSource authLocalDataSource;
  final GoRouter router;
  AuthNotifier({
    required this.loginUseCase,
    required this.authCredentialNotifier,
    required this.globalAuth,
    required this.getSessionUseCase,
    required this.saveAuthDataUseCase,
    required this.clearTokenUseCase,
    required this.authLocalDataSource,
    required this.router,
  }) : super(const AuthState.initial()) {
    _checkSavedAuth();
  }

  Future<void> _checkSavedAuth() async {
    state = const AuthState.checkingSavedAuth();
    Session? session = await getSessionUseCase.execute();

    // Check for saved credentials if no active session
    if (session == null || session.isExpired) {
      final hasRememberCredentials = await authLocalDataSource.hasRememberCredentials();
      if (hasRememberCredentials) {
        final savedCredentials = await authLocalDataSource.getRememberCredentials();
        if (savedCredentials != null) {
          // Attempt auto-login with saved credentials
          try {
            final success = await login(
              savedCredentials['username']!,
              savedCredentials['password']!,
              true, // Keep remember me true
            );
            if (success) {
              return; // Auto-login successful, no need to continue
            }
          } catch (e) {
            // Auto-login failed, clear saved credentials
            await authLocalDataSource.clearRememberCredentials();
          }
        }
      }
    }

    await Supabase.instance.client.auth.onAuthStateChange.listen((event) {
      if (event.session != null && !event.session!.isExpired) {
        globalAuth.setToken(event.session!);
        state = AuthState.completed(event.session!);
        authCredentialNotifier.setCredentials(session?.accessToken ?? "");
      } else {
        state = const AuthState.initial();
      }
    });
  }

  Future<bool> login(String username, String password, [bool rememberMe = false]) async {
    state = const AuthState.loggingIn();
    bool status = false;

    try {
      final loginResult = await loginUseCase.execute(username, password);

      late AuthResponse authResponse;

      await loginResult.fold(
        (failure) async {
          state = AuthState.error(mapLoginFailure(failure));
        },
        (response) async {
          authResponse = response;
          if (authResponse.session != null) {
            await saveAuthDataUseCase.execute(authResponse);
            
            // Save credentials if remember me is enabled
            if (rememberMe) {
              await _saveRememberCredentials(username, password);
            } else {
              await _clearRememberCredentials();
            }
            
            globalAuth.setToken(authResponse.session!);
            authCredentialNotifier
                .setCredentials(authResponse.session?.accessToken ?? '');
            status = true;
            state = AuthState.loggedIn(authResponse.session!);
          } else {
            state = AuthState.error(
              handleException(
                exception: Exception("Login failed, no session returned."),
                message: "Login failed, please try again.",
              ),
            );
          }
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
      await authLocalDataSource.clearRememberCredentials(); // Clear remembered credentials on logout
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

  Future<void> _saveRememberCredentials(String username, String password) async {
    await authLocalDataSource.saveRememberCredentials(username, password);
  }

  Future<void> _clearRememberCredentials() async {
    await authLocalDataSource.clearRememberCredentials();
  }
}
