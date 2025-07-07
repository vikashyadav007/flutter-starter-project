import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_entity.dart';

part 'consumables_cart.freezed.dart';

@freezed
class ConsumablesCart with _$ConsumablesCart {
  const factory ConsumablesCart({
    required ConsumablesEntity consumables,
    required int quantity,
  }) = _ConsumablesCart;
}
