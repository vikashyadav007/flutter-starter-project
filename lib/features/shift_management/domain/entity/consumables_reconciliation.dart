import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_project/features/shift_management/domain/entity/shift_consumables_entity.dart';

part 'consumables_reconciliation.freezed.dart';

@freezed
class ConsumablesReconciliation with _$ConsumablesReconciliation {
  const factory ConsumablesReconciliation({
    required ShiftConsumablesEntity shiftConsumables,
    required String returns,
    required int sold,
    required double soldPrice,
  }) = _ConsumablesReconciliation;
}
