import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_setting_entity.dart';

part 'pump_setting_model.freezed.dart';
part 'pump_setting_model.g.dart';

@freezed
abstract class PumpSettingModel with _$PumpSettingModel {
  const PumpSettingModel._();
  const factory PumpSettingModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "pump_number") String? pumpNumber,
    @JsonKey(name: "nozzle_count") int? nozzleCount,
    @JsonKey(name: "fuel_types") List<String>? fuelTypes,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "fuel_pump_id") String? fuelPumpId,
  }) = _PumpSettingModel;

  factory PumpSettingModel.fromJson(Map<String, dynamic> json) =>
      _$PumpSettingModelFromJson(json);

  toEntity() {
    return PumpSettingEntity(
      id: id,
      pumpNumber: pumpNumber,
      nozzleCount: nozzleCount,
      fuelTypes: fuelTypes ?? [],
      createdAt: createdAt,
      fuelPumpId: fuelPumpId,
    );
  }
}
