import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/fuel_entity.dart';

final selectedFuelProvider =
    StateNotifierProvider<SelectedFuelNotifier, FuelEntity?>(
  (ref) => SelectedFuelNotifier(),
);

class SelectedFuelNotifier extends StateNotifier<FuelEntity?> {
  SelectedFuelNotifier() : super(null);

  void setFuel(FuelEntity fuel) {
    state = fuel;
  }

  get selectedFuel => state;

  void clearFuel() {
    state = null;
  }
}
