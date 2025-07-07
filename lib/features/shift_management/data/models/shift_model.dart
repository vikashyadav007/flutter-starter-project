import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_entity.dart';

import 'package:fuel_pro_360/features/shift_management/data/models/staff_model.dart';

part 'shift_model.freezed.dart';
part 'shift_model.g.dart';

ShiftModel shiftModelFromJson(String str) =>
    ShiftModel.fromJson(json.decode(str));

String shiftModelToJson(ShiftModel data) => json.encode(data.toJson());

@freezed
abstract class ShiftModel with _$ShiftModel {
  const ShiftModel._();
  const factory ShiftModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "staff_id") String? staffId,
    @JsonKey(name: "shift_type") String? shiftType,
    @JsonKey(name: "start_time") DateTime? startTime,
    @JsonKey(name: "end_time") DateTime? endTime,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "cash_remaining") int? cashRemaining,
    @JsonKey(name: "fuel_pump_id") String? fuelPumpId,
    @JsonKey(name: "staff") StaffModel? staff,
  }) = _ShiftModel;

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);

  toEntity() {
    return ShiftEntity(
      id: id,
      staffId: staffId,
      shiftType: shiftType,
      startTime: startTime,
      endTime: endTime,
      status: status,
      createdAt: createdAt,
      cashRemaining: cashRemaining,
      fuelPumpId: fuelPumpId,
      staff: staff?.toEntity(),
    );
  }
}
