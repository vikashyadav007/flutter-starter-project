import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/customers/domain/entity/customer_entity.dart';
import 'package:fuel_pro_360/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/active_staff_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/add_new_vehicle_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/create_indent_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_customer_indent_booklet_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/upload_meter_reading_image_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/create_indent_success_popup.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';
import 'package:uuid/uuid.dart';

part 'add_new_vehicle_provider.freezed.dart';

@freezed
class AddNewVehicleState with _$AddNewVehicleState {
  const factory AddNewVehicleState.initial() = _Initial;
  const factory AddNewVehicleState.submitting() = _Submitting;
  const factory AddNewVehicleState.submitted(bool success) = _Submitted;
  const factory AddNewVehicleState.error(String message) = _Error;
}

final AddNewVehicleProvider =
    StateNotifierProvider<AddNewVehicleNotifier, AddNewVehicleState>((ref) {
  final selectedCustomer = ref.watch(selectedCustomerProvider);
  final vehicleNumber = ref.watch(vehicleNumberProvider);
  final vehicleType = ref.watch(vehicleTypeProvider);
  final capacity = ref.watch(capacityProvider);
  final selectedFuelPump = ref.watch(selectedFuelPumpProvider);
  final selectedVehicle = ref.watch(selectedCustomerVehicleProvider.notifier);

  final addNewVehicleUsecase = ref.watch(addNewVehicleUsecaseProvider);

  return AddNewVehicleNotifier(
    ref: ref,
    selectedCustomer: selectedCustomer,
    vehicleNumber: vehicleNumber,
    vehicleType: vehicleType,
    capacity: capacity,
    addNewVehicleUsecase: addNewVehicleUsecase,
    selectedFuelPumpEntity: selectedFuelPump,
    selectedVehicle: selectedVehicle,
  );
});

class AddNewVehicleNotifier extends StateNotifier<AddNewVehicleState> {
  Ref ref;
  CustomerEntity? selectedCustomer;
  String vehicleNumber = "";
  String vehicleType = "";
  String capacity = "";
  AddNewVehicleUsecase addNewVehicleUsecase;
  StateController<VehicleEntity?> selectedVehicle;

  FuelPumpEntity? selectedFuelPumpEntity;

  AddNewVehicleNotifier(
      {required this.ref,
      required this.selectedCustomer,
      required this.vehicleNumber,
      required this.vehicleType,
      required this.capacity,
      required this.addNewVehicleUsecase,
      required this.selectedFuelPumpEntity,
      required this.selectedVehicle})
      : super(const AddNewVehicleState.initial());

  Future<void> addNewVehicle() async {
    var body = {
      "customer_id": selectedCustomer?.id ?? "",
      "number": vehicleNumber,
      "type": vehicleType,
      "capacity": capacity,
      "fuel_pump_id": selectedFuelPumpEntity?.id ?? "",
    };

    var result = await addNewVehicleUsecase.execute(body: body);
    result.fold(
      (failure) => state = AddNewVehicleState.error(failure.message),
      (vehicleEntity) async {
        state = AddNewVehicleState.submitted(true);
        // Invalidate and wait for the new list to load
        await ref.refresh(customerVehicleListProvider.future);

        // Optionally: ensure this new vehicle is still set as selected (if needed again)
        selectedVehicle.state = vehicleEntity;
      },
    );
  }

  // {id: 9ce6e3e7-e9d6-40d7-a850-7ba911dc3027,
  //customer_id: 6f38b71f-bf6b-4162-b5e3-6e4bddbea5e1,
  //number: KAAB1234,
  // type: Truck,
  // capacity: test ,
  //created_at: 2025-03-11T06:13:39.084708+00:00,
  //fuel_pump_id: 2c762f9c-f89b-4084-9ebe-b6902fdf4311}

  void reset() {
    state = const AddNewVehicleState.initial();
  }
}
