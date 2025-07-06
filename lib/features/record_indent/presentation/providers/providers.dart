import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/data/data_sources/record_indent_data_source.dart';
import 'package:starter_project/features/record_indent/data/respositories/record_indent_repository_impl.dart';
import 'package:starter_project/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:starter_project/features/record_indent/domain/repositories/record_indent_repository.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/create_indent_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_all_customer_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_indent_booklet_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_vehicle_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_fuel_types_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_indent_booklets_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_staffs_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/verify_customer_indent_usecase.dart';
import 'package:starter_project/shared/providers/selected_fuel_pump.dart';

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

final getStaffsUsecaseProvider = Provider<GetStaffsUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetStaffsUsecase(recordIndentRepository);
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
