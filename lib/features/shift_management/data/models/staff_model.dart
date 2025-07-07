import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:fuel_pro_360/features/shift_management/domain/entity/staff_entity.dart';

part 'staff_model.freezed.dart';
part 'staff_model.g.dart';

@freezed
abstract class StaffModel with _$StaffModel {
  const StaffModel._();
  const factory StaffModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "role") String? role,
    @JsonKey(name: "salary") int? salary,
    @JsonKey(name: "joining_date") DateTime? joiningDate,
    @JsonKey(name: "auth_id") String? authId,
    @JsonKey(name: "is_active") bool? isActive,
    @JsonKey(name: "staff_numeric_id") String? staffNumericId,
    @JsonKey(name: "fuel_pump_id") String? fuelPumpId,
    @JsonKey(name: "mobile_only_access") bool? mobileOnlyAccess,
  }) = _StaffModel;

  factory StaffModel.fromJson(Map<String, dynamic> json) =>
      _$StaffModelFromJson(json);

  toEntity() {
    return StaffEntity(
      id: id,
      name: name,
      staffNumericId: staffNumericId,
      phone: phone,
      email: email,
      role: role,
      salary: salary,
      joiningDate: joiningDate,
      authId: authId,
      isActive: isActive,
      fuelPumpId: fuelPumpId,
      mobileOnlyAccess: mobileOnlyAccess,
    );
  }
}
