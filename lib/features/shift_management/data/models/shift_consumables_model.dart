import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:fuel_pro_360/features/shift_management/data/models/consumables_model.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_consumables_entity.dart';

part 'shift_consumables_model.freezed.dart';
part 'shift_consumables_model.g.dart';

@freezed
abstract class ShiftConsumablesModel with _$ShiftConsumablesModel {
  const ShiftConsumablesModel._();
  const factory ShiftConsumablesModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "shift_id") String? shiftId,
    @JsonKey(name: "quantity_allocated") int? quantityAllocated,
    @JsonKey(name: "quantity_returned") dynamic quantityReturned,
    @JsonKey(name: "consumable_id") String? consumableId,
    @JsonKey(name: "consumables") ConsumablesModel? consumables,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
  }) = _ShiftConsumablesModel;

  factory ShiftConsumablesModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftConsumablesModelFromJson(json);

  ShiftConsumablesEntity toEntity() {
    return ShiftConsumablesEntity(
      id: id,
      quantityAllocated: quantityAllocated,
      quantityReturned: quantityReturned,
      consumableId: consumableId,
      consumables: consumables?.toEntity(),
      shiftId: shiftId,
      status: status,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
