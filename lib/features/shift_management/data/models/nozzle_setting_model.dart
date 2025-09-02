import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:fuel_pro_360/features/shift_management/domain/entity/nozzle_setting_entity.dart';

part 'nozzle_setting_model.freezed.dart';
part 'nozzle_setting_model.g.dart';

@freezed
abstract class NozzleSettingModel with _$NozzleSettingModel {
  const NozzleSettingModel._();
  const factory NozzleSettingModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "pump_id") String? pumpId,
    @JsonKey(name: "nozzle_number") int? nozzleNumber,
    @JsonKey(name: "fuel_type") String? fuelType,
    @JsonKey(name: "nozzle_name") String? nozzleName,
    @JsonKey(name: "is_active") bool? isActive,
    @JsonKey(name: "fuel_pump_id") String? fuelPumpId,
    @JsonKey(name: "created_at") DateTime? createdAt,
  }) = _NozzleSettingModel;

  factory NozzleSettingModel.fromJson(Map<String, dynamic> json) =>
      _$NozzleSettingModelFromJson(json);

  toEntity() => NozzleSettingEntity(
        id: id,
        pumpId: pumpId,
        nozzleNumber: nozzleNumber,
        fuelType: fuelType,
        nozzleName: nozzleName,
        isActive: isActive,
        fuelPumpId: fuelPumpId,
        createdAt: createdAt,
      );
}
