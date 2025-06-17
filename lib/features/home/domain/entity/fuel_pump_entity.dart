// To parse this JSON data, do
//
//     final fuelPumpEntity = fuelPumpEntityFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'fuel_pump_entity.freezed.dart';

@freezed
class FuelPumpEntity with _$FuelPumpEntity {
  const factory FuelPumpEntity({
    required String id,
    required String name,
    required String email,
    required String address,
    required String contactNumber,
    required String status,
    required dynamic createdBy,
    required DateTime createdAt,
  }) = _FuelPumpEntity;
}
