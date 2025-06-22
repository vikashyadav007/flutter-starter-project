import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';

final selectedFuelPumpProvider =
    StateNotifierProvider<SelectedFuelPumpNotifier, FuelPumpEntity?>((ref) {
  return SelectedFuelPumpNotifier();
});

class SelectedFuelPumpNotifier extends StateNotifier<FuelPumpEntity?> {
  SelectedFuelPumpNotifier() : super(null);

  void selectFuelPump(FuelPumpEntity? fuelPump) {
    state = fuelPump;
  }

  void clearSelection() {
    state = null;
  }
}
