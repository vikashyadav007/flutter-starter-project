import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:fuel_pro_360/features/record_indent/domain/entity/fuel_entity.dart';

part 'fuel_model.freezed.dart';
part 'fuel_model.g.dart';

@freezed
abstract class FuelModel with _$FuelModel {
  const FuelModel._();
  const factory FuelModel({
    @JsonKey(name: "fuel_type") required String fuelType,
    @JsonKey(name: "current_price") required double currentPrice,
  }) = _FuelModel;

  factory FuelModel.fromJson(Map<String, dynamic> json) =>
      _$FuelModelFromJson(json);

  toEntity() {
    return FuelEntity(
      fuelType: fuelType,
      currentPrice: currentPrice,
    );
  }
}
