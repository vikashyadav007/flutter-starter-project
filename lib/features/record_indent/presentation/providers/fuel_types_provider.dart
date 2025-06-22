import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/fuel_entity.dart';

final fuelTypesProvider =
    StateNotifierProvider<FuelTypesNotifier, List<FuelEntity>>(
  (ref) => FuelTypesNotifier(),
);

class FuelTypesNotifier extends StateNotifier<List<FuelEntity>> {
  FuelTypesNotifier() : super([]);

  void setFuels(List<FuelEntity> fuels) {
    state = fuels;
  }

  void clearFuels() {
    state = [];
  }
}
