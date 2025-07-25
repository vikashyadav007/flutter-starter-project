import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/reading_entity.dart';
import 'dart:convert';

import 'package:fuel_pro_360/features/shift_management/domain/entity/staff_entity.dart';

part 'shift_entity.freezed.dart';

@freezed
class ShiftEntity with _$ShiftEntity {
  const factory ShiftEntity({
    String? id,
    String? staffId,
    String? shiftType,
    DateTime? startTime,
    DateTime? endTime,
    String? status,
    DateTime? createdAt,
    int? cashRemaining,
    String? fuelPumpId,
    StaffEntity? staff,
    List<ReadingEntity>? readings,
  }) = _ShiftEntity;
}
