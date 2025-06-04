import 'package:freezed_annotation/freezed_annotation.dart';

part 'refresh_response_entity.freezed.dart';

@freezed
class RefreshResponseEntity with _$RefreshResponseEntity {
  const factory RefreshResponseEntity({
    required String access,
  }) = _RefreshResponseEntity;
}
