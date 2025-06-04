import 'package:starter_project/features/auth/domain/entity/login_response_entity.dart';
import 'package:starter_project/features/auth/domain/entity/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_entity.freezed.dart';

@freezed
class AuthEntity with _$AuthEntity {
  const factory AuthEntity({
    LoginResponseEntity? loginResponse,
    UserEntity? user,
    @Default(false) bool isAuthenticated,
  }) = _AuthEntity;
}
