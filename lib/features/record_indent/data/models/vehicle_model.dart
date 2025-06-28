import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:starter_project/features/record_indent/domain/entity/vehicle_entity.dart';

part 'vehicle_model.freezed.dart';
part 'vehicle_model.g.dart';

@freezed
abstract class VehicleModel with _$VehicleModel {
  const VehicleModel._();
  const factory VehicleModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "customer_id") String? customerId,
    @JsonKey(name: "number") String? number,
    @JsonKey(name: "type") String? type,
    @JsonKey(name: "capacity") String? capacity,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "fuel_pump_id") String? fuelPumpId,
  }) = _VehicleModel;

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  toEntity() {
    return VehicleEntity(
      id: id,
      customerId: customerId,
      number: number,
      type: type,
      capacity: capacity,
      createdAt: createdAt,
      fuelPumpId: fuelPumpId,
    );
  }
}
