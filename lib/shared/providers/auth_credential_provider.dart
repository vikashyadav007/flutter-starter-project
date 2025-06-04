import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final authCredentialProvider =
    NotifierProvider<AuthCredentialNotifier, AuthCredentials?>(() {
  return AuthCredentialNotifier();
});

class AuthCredentialNotifier extends Notifier<AuthCredentials?> {
  @override
  AuthCredentials? build() => null;

  void setCredentials(String token) {
    state = AuthCredentials(token: token);
  }

  void clearCredentials() {
    state = null;
  }
}

class AuthCredentials {
  final String? token;

  AuthCredentials({this.token});

  String get basicAuth {
    return 'Bearer $token';
  }
}
