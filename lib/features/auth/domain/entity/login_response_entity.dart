import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_entity.freezed.dart';

@freezed
class LoginResponseEntity with _$LoginResponseEntity {
  const factory LoginResponseEntity({
    required String refresh,
    required String access,
  }) = _LoginResponseEntity;
}
