import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/core/routing/app_router.dart';
import 'package:starter_project/features/auth/domain/entity/login_response_entity.dart';
import 'package:starter_project/features/auth/domain/use_cases/clear_token_use_case.dart';
import 'package:starter_project/features/auth/domain/use_cases/get_token_use_case.dart';
import 'package:starter_project/features/auth/domain/use_cases/login_use_case.dart';
import 'package:starter_project/features/auth/domain/use_cases/save_auth_data_use_case.dart';
import 'package:starter_project/features/auth/presentation/providers/auth_error_mapper.dart';
import 'package:starter_project/features/auth/presentation/providers/global_auth_provider.dart';
import 'package:starter_project/features/auth/presentation/providers/providers.dart';
import 'package:starter_project/shared/providers/auth_credential_provider.dart';
import 'package:starter_project/shared/utils/handle_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loggingIn() = _LoggingIn;
  const factory AuthState.checkingSavedAuth() = _CheckingSavedAuth;
  const factory AuthState.loggedIn(LoginResponseEntity loginResponse) =
      _LoggedIn;
  const factory AuthState.fetchingProfile() = _FetchingProfile;

  //TODO add here user profile
  const factory AuthState.completed(LoginResponseEntity loginResponse) =
      _Completed;
  const factory AuthState.error(Failure error) = _Error;
  const factory AuthState.loggingOut() = _LoggingOut;
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // final LoginUseCase = ref.watch(loginUserCas);
  final authCredentialNotifier = ref.watch(authCredentialProvider.notifier);
  final loginUseCase = ref.watch(loginUseCaseProvider);
  final getTokenUseCase = ref.watch(getTokenUseCaseProvider);
  final saveAuthDataUseCase = ref.watch(saveAuthDataUseCaseProvider);
  final globalAuth = ref.watch(globalAuthProvider.notifier);
  final clearTokenUseCase = ref.watch(clearTokenUseCaseProvider);

  final router = ref.watch(routerProvider);

  return AuthNotifier(
    loginUseCase: loginUseCase,
    authCredentialNotifier: authCredentialNotifier,
    globalAuth: globalAuth,
    getTokenUseCase: getTokenUseCase,
    saveAuthDataUseCase: saveAuthDataUseCase,
    clearTokenUseCase: clearTokenUseCase,
    router: router,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase loginUseCase;
  final GetTokenUseCase getTokenUseCase;
  final SaveAuthDataUseCase saveAuthDataUseCase;
  final AuthCredentialNotifier authCredentialNotifier;
  final GlobalAuth globalAuth;
  final ClearTokenUseCase clearTokenUseCase;
  final GoRouter router;
  AuthNotifier({
    required this.loginUseCase,
    required this.authCredentialNotifier,
    required this.globalAuth,
    required this.getTokenUseCase,
    required this.saveAuthDataUseCase,
    required this.clearTokenUseCase,
    required this.router,
  }) : super(const AuthState.initial()) {
    print("this one is called 89898989");
    _checkSavedAuth();
  }

  Future<void> _checkSavedAuth() async {
    state = const AuthState.checkingSavedAuth();
    final loginEntity = await getTokenUseCase.execute();

    if (loginEntity != null) {
      globalAuth.setToken(loginEntity);
      state = AuthState.completed(loginEntity);
      authCredentialNotifier.setCredentials(loginEntity.access);
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

      late LoginResponseEntity loginResponse;

      state = loginResult.fold(
        (failure) {
          return AuthState.error(mapLoginFailure(failure));
        },
        (response) {
          loginResponse = response;
          saveAuthDataUseCase.execute(loginResponse);
          globalAuth.setToken(loginResponse);
          authCredentialNotifier.setCredentials(loginResponse.access);
          status = true;
          return AuthState.loggedIn(loginResponse);
        },
      );

      state = AuthState.completed(loginResponse);

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
