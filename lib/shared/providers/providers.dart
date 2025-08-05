import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_cart.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';

final totalConsumablesCostProvider = StateProvider<double>((ref) {
  final consumablesCartState = ref.watch(consumablesCartProvider);

  double totalCost = 0.0;

  for (ConsumablesCart item in consumablesCartState) {
    totalCost += (item.quantity) * (item.consumables.pricePerUnit ?? 0.0);
  }

  return totalCost;
});
