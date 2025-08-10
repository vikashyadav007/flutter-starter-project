import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/customers/domain/entity/customer_entity.dart';
import 'package:fuel_pro_360/features/record_indent/data/data_sources/record_indent_data_source.dart';
import 'package:fuel_pro_360/features/record_indent/data/respositories/record_indent_repository_impl.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/active_staff_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/add_new_vehicle_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/create_consumables_transactions_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/create_indent_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_all_customer_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_customer_indent_booklet_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_customer_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_customer_vehicle_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_fuel_types_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_indent_booklets_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_active_staffs_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/update_consumables_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/upload_meter_reading_image_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/verify_customer_indent_usecase.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';

final RecordsProvider = Provider<RecordIndentRepository>((ref) {
  final recordIndentDataSource = RecordIndentDataSource();
  return RecordIndentRepositoryImpl(
      recordIndentDataSource: recordIndentDataSource);
});

final getCustomerIndentUsecaseProvider =
    Provider<GetCustomerIndentUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetCustomerIndentUsecase(recordIndentRepository);
});

final getCustomerVehicleUsecaseProvider =
    Provider<GetCustomerVehicleUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetCustomerVehicleUsecase(recordIndentRepository);
});

final getFuelTypesUsecaseProvider = Provider<GetFuelTypesUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetFuelTypesUsecase(recordIndentRepository);
});

final searchCustomerUsecaseProvider =
    Provider<GetCustomerVehicleUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetCustomerVehicleUsecase(recordIndentRepository);
});

final verifyCustomerIndentUsecaseProvider =
    Provider<VerifyCustomerIndentUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return VerifyCustomerIndentUsecase(recordIndentRepository);
});

final getIndentBookletUsecaseProvider =
    Provider<GetIndentBookletsUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetIndentBookletsUsecase(recordIndentRepository);
});

final getCustomerUsecaseProvider = Provider<GetCustomerUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetCustomerUsecase(recordIndentRepository);
});

final createIndentUsecaseProvider = Provider<CreateIndentUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return CreateIndentUsecase(recordIndentRepository);
});

final getAllCustomersUsecaseProvider = Provider<GetAllCustomersUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetAllCustomersUsecase(recordIndentRepository);
});

final indentNumberProvider = StateProvider<String>((ref) => '');
final amountProvider = StateProvider<String>((ref) => '');
final quantityProvider = StateProvider<String>((ref) => '');
final selectedTabIndexProvider = StateProvider<int>((ref) => 0);
final indentNumberVerifiedProvider = StateProvider<bool>((ref) => false);

final fuelTypesMapProvider =
    StateProvider<Map<String, FuelEntity>>((ref) => {});

final fuelTypesProvider = FutureProvider<List<FuelEntity>>((ref) async {
  final getFuelTypesUsecase = ref.watch(getFuelTypesUsecaseProvider);
  final selectedFuelPump = ref.watch(selectedFuelPumpProvider);
  final result = await getFuelTypesUsecase.execute(
    fuelPumpId: selectedFuelPump?.id ?? '',
  );
  return result.fold((failure) => throw Exception(failure.message),
      (fuelTypes) {
    Map<String, FuelEntity> fuelTypesMap = {};

    for (var fuel in fuelTypes) {
      fuelTypesMap[fuel.fuelType ?? ""] = fuel;
    }
    print("objects from getFuelTypes1212: $fuelTypesMap");
    ref.read(fuelTypesMapProvider.notifier).state = fuelTypesMap;

    return fuelTypes;
  });
});

final allCustomersProvider =
    FutureProvider.autoDispose<List<CustomerEntity>>((ref) async {
  final getAllCustomersUsecase = ref.watch(getAllCustomersUsecaseProvider);
  final selectedPump = ref.watch(selectedFuelPumpProvider);
  final result =
      await getAllCustomersUsecase.execute(fuelPumpId: selectedPump?.id ?? '');
  return result.fold(
      (failure) => throw Exception(failure.message), (customers) => customers);
});

final selectedCustomerProvider = StateProvider<CustomerEntity?>((ref) => null);

final customerIndentProvider =
    FutureProvider<List<IndentBookletEntity>>((ref) async {
  final getCustomerIndentBookletUsecase =
      ref.watch(getCustomerIndentUsecaseProvider);
  final selectedCustomer = ref.watch(selectedCustomerProvider);
  final selectedPump = ref.watch(selectedFuelPumpProvider);
  final result = await getCustomerIndentBookletUsecase.execute(
    customerId: selectedCustomer?.id ?? '',
    fuelPumpId: selectedPump?.id ?? '',
  );
  return result.fold((failure) => throw Exception(failure.message),
      (indentBooklets) => indentBooklets);
});

final selectedCustomerVehicleProvider =
    StateProvider<VehicleEntity?>((ref) => null);

final selectedIndentBookletProvider =
    StateProvider<IndentBookletEntity?>((ref) => null);

final selectedFuelProvider = StateProvider<FuelEntity?>((ref) => null);

final customerVehicleListProvider =
    FutureProvider<List<VehicleEntity>>((ref) async {
  final getCustomerVehicleUsecase =
      ref.watch(getCustomerVehicleUsecaseProvider);
  final selectedCustomer = ref.watch(selectedCustomerProvider);
  final selectedPump = ref.watch(selectedFuelPumpProvider);
  final result = await getCustomerVehicleUsecase.execute(
    customerId: selectedCustomer?.id ?? '',
    fuelPumpId: selectedPump?.id ?? '',
  );
  return result.fold(
      (failure) => throw Exception(failure.message), (vehicles) => vehicles);
});

final meterReadingImageProvider = StateProvider<File?>((ref) => null);

final uploadMeterReadingImageUsecaseProvider =
    Provider<UploadMeterReadingImageUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return UploadMeterReadingImageUsecase(recordIndentRepository);
});

final getActiveStaffsUsecaseProvider = Provider<GetActiveStaffsUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetActiveStaffsUsecase(recordIndentRepository);
});

final activeStaffProvider =
    FutureProvider<List<ActiveStaffEntity>>((ref) async {
  final getActiveStaffsUsecase = ref.watch(getActiveStaffsUsecaseProvider);
  final selectedPump = ref.watch(selectedFuelPumpProvider);
  final result = await getActiveStaffsUsecase.execute(
    fuelPumpId: selectedPump?.id ?? '',
  );
  return result.fold(
      (failure) => throw Exception(failure.message), (staffs) => staffs);
});

final selectedActiveStaffProvider =
    StateProvider<ActiveStaffEntity?>((ref) => null);

final vehicleNumberProvider = StateProvider<String>((ref) => "");
final vehicleTypeProvider = StateProvider<String>((ref) => "Truck");
final capacityProvider = StateProvider<String>((ref) => "");

final addNewVehicleUsecaseProvider = Provider<AddNewVehicleUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return AddNewVehicleUsecase(recordIndentRepository);
});

final billNumberProvider = StateProvider<String>((ref) => "");

final indentDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final noIndentCheckboxProvider = StateProvider<bool>((ref) => false);

final createConsumablesTransactionsUsecaseProvider =
    Provider<CreateConsumablesTransactionsUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return CreateConsumablesTransactionsUsecase(recordIndentRepository);
});

final updateConsumablesUsecaseProvider =
    Provider<UpdateConsumablesUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return UpdateConsumablesUsecase(recordIndentRepository);
});



