import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:starter_project/features/shift_management/domain/entity/consumables_entity.dart';

part 'consumables_model.freezed.dart';
part 'consumables_model.g.dart';

@freezed
abstract class ConsumablesModel with _$ConsumablesModel {
  const ConsumablesModel._();
  const factory ConsumablesModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "quantity") int? quantity,
    @JsonKey(name: "price_per_unit") double? pricePerUnit,
    @JsonKey(name: "total_price") int? totalPrice,
    @JsonKey(name: "date") DateTime? date,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "category") String? category,
    @JsonKey(name: "unit") String? unit,
    @JsonKey(name: "fuel_pump_id") String? fuelPumpId,
  }) = _ConsumablesModel;

  factory ConsumablesModel.fromJson(Map<String, dynamic> json) =>
      _$ConsumablesModelFromJson(json);

  toEntity() {
    return ConsumablesEntity(
      id: id,
      name: name,
      quantity: quantity,
      pricePerUnit: pricePerUnit,
      totalPrice: totalPrice,
      date: date,
      createdAt: createdAt,
      category: category,
      unit: unit,
      fuelPumpId: fuelPumpId,
    );
  }
}
