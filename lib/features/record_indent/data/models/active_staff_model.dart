import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:fuel_pro_360/features/record_indent/domain/entity/active_staff_entity.dart';

part 'active_staff_model.freezed.dart';
part 'active_staff_model.g.dart';

@freezed
abstract class ActiveStaffModel with _$ActiveStaffModel {
  const ActiveStaffModel._();
  const factory ActiveStaffModel({
    @JsonKey(name: "staff_id") String? staffId,
    @JsonKey(name: "staff_name") String? staffName,
    @JsonKey(name: "shift_id") String? shiftId,
    @JsonKey(name: "pump_display") String? pumpDisplay,
    @JsonKey(name: "display_name") String? displayName,
  }) = _ActiveStaffModel;

  factory ActiveStaffModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveStaffModelFromJson(json);

  ActiveStaffEntity toEntity() {
    return ActiveStaffEntity(
      staffId: staffId,
      staffName: staffName,
      shiftId: shiftId,
      pumpDisplay: pumpDisplay,
      displayName: displayName,
    );
  }
}
