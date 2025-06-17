import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';

part 'fuel_pump_model.freezed.dart';
part 'fuel_pump_model.g.dart';

@freezed
abstract class FuelPumpModel with _$FuelPumpModel {
  const FuelPumpModel._();
  const factory FuelPumpModel({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "email") required String email,
    @JsonKey(name: "address") required String address,
    @JsonKey(name: "contact_number") required String contactNumber,
    @JsonKey(name: "status") required String status,
    @JsonKey(name: "created_by") required dynamic createdBy,
    @JsonKey(name: "created_at") required DateTime createdAt,
  }) = _FuelPumpModel;

  factory FuelPumpModel.fromJson(Map<String, dynamic> json) =>
      _$FuelPumpModelFromJson(json);

  toEntity() {
    return FuelPumpEntity(
      id: id,
      name: name,
      email: email,
      address: address,
      contactNumber: contactNumber,
      status: status,
      createdBy: createdBy,
      createdAt: createdAt,
    );
  }
}
