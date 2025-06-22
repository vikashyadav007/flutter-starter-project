import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/vehicle_entity.dart';

final selectedCustomerVehicleProvider =
    StateNotifierProvider<SelectedCustomerVehicleNotifier, VehicleEntity?>(
  (ref) => SelectedCustomerVehicleNotifier(),
);

class SelectedCustomerVehicleNotifier extends StateNotifier<VehicleEntity?> {
  SelectedCustomerVehicleNotifier() : super(null);

  void setSelectedVehicle(VehicleEntity vehicle) {
    state = vehicle;
  }

  get vehile => state;

  void clearVehicle() {
    state = null;
  }
}
