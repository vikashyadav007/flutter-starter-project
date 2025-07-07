import 'package:fuel_pro_360/features/auth/domain/entity/refresh_response_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_response_model.freezed.dart';
part 'refresh_response_model.g.dart';

@freezed
abstract class RefreshResponseModel with _$RefreshResponseModel {
  const RefreshResponseModel._();
  const factory RefreshResponseModel({
    @JsonKey(name: "access") required String access,
  }) = _RefreshResponseModel;

  factory RefreshResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseModelFromJson(json);

  toEntity() {
    return RefreshResponseEntity(access: access);
  }
}
