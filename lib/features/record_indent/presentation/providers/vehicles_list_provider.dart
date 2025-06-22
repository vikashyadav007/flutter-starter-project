import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/domain/entity/vehicle_entity.dart';

final customerVehicleListProvider =
    StateNotifierProvider<CustomerVehicleListNotifier, List<VehicleEntity>>(
  (ref) => CustomerVehicleListNotifier(),
);

class CustomerVehicleListNotifier extends StateNotifier<List<VehicleEntity>> {
  CustomerVehicleListNotifier() : super([]);

  void setVehicles(List<VehicleEntity> vehicles) {
    state = vehicles;
  }

  void clearVehicles() {
    state = [];
  }
}
