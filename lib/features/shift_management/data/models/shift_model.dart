import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:starter_project/features/shift_management/domain/entity/shift_entity.dart';

import 'package:starter_project/features/shift_management/data/models/staff_model.dart';

part 'shift_model.freezed.dart';
part 'shift_model.g.dart';

ShiftModel shiftModelFromJson(String str) =>
    ShiftModel.fromJson(json.decode(str));

String shiftModelToJson(ShiftModel data) => json.encode(data.toJson());

@freezed
abstract class ShiftModel with _$ShiftModel {
  const ShiftModel._();
  const factory ShiftModel({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "staff_id") required String staffId,
    @JsonKey(name: "shift_type") required String shiftType,
    @JsonKey(name: "start_time") required DateTime startTime,
    @JsonKey(name: "end_time") required DateTime endTime,
    @JsonKey(name: "status") required String status,
    @JsonKey(name: "created_at") required DateTime createdAt,
    @JsonKey(name: "cash_remaining") required int cashRemaining,
    @JsonKey(name: "fuel_pump_id") required String fuelPumpId,
    @JsonKey(name: "staff") required StaffModel staff,
  }) = _ShiftModel;

  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);

  ShiftEntity toEntity() {
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
      staff: staff.toEntity(),
    );
  }
}
