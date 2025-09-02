import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'nozzle_setting_entity.freezed.dart';

@freezed
class NozzleSettingEntity with _$NozzleSettingEntity {
  const factory NozzleSettingEntity({
    String? id,
    String? pumpId,
    int? nozzleNumber,
    String? fuelType,
    String? nozzleName,
    bool? isActive,
    String? fuelPumpId,
    DateTime? createdAt,
  }) = _NozzleSettingEntity;
}
