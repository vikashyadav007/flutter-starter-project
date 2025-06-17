import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';

part 'shift_entity.freezed.dart';

@freezed
class ShiftEntity with _$ShiftEntity {
  const factory ShiftEntity({
    required String id,
    required String staffId,
    required String shiftType,
    required DateTime startTime,
    required DateTime endTime,
    required String status,
    required DateTime createdAt,
    required int cashRemaining,
    required String fuelPumpId,
    required StaffEntity staff,
  }) = _ShiftEntity;
}
