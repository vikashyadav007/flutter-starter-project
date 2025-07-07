import 'package:fuel_pro_360/features/auth/domain/entity/login_response_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

@freezed
abstract class LoginResponseModel with _$LoginResponseModel {
  const LoginResponseModel._();
  const factory LoginResponseModel({
    @JsonKey(name: "refresh") required String refresh,
    @JsonKey(name: "access") required String access,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  toEntity() {
    return LoginResponseEntity(refresh: refresh, access: access);
  }
}
