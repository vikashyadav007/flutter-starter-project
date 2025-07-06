import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:starter_project/features/shift_management/domain/entity/consumables_entity.dart';

part 'shift_consumables_entity.freezed.dart';

@freezed
class ShiftConsumablesEntity with _$ShiftConsumablesEntity {
  const factory ShiftConsumablesEntity({
    String? id,
    int? quantityAllocated,
    dynamic quantityReturned,
    String? consumableId,
    ConsumablesEntity? consumables,
  }) = _ShiftConsumablesEntity;
}
