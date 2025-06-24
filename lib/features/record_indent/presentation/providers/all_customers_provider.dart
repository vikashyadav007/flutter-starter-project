import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_all_customer_usecase.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/shared/providers/selected_fuel_pump.dart';

part 'all_customers_provider.freezed.dart';

@freezed
class AllCustomersState with _$AllCustomersState {
  factory AllCustomersState.initial() = _InitialAllCustomersState;
  factory AllCustomersState.loading() = _LoadingAllCustomersState;
  factory AllCustomersState.loaded(List<CustomerEntity> customers) =
      _LoadedAllCustomersState;
  factory AllCustomersState.error(String message) = _ErrorAllCustomersState;
}

final allCustomersProvider =
    StateNotifierProvider<AllCustomersNotifier, AllCustomersState>((ref) {
  final getAllCustomersUsecase = ref.watch(getAllCustomersUsecaseProvider);
  final selectedPump = ref.watch(selectedFuelPumpProvider);

  return AllCustomersNotifier(
    getAllCustomersUsecase: getAllCustomersUsecase,
    selectedFuelPump: selectedPump,
  );
});

class AllCustomersNotifier extends StateNotifier<AllCustomersState> {
  GetAllCustomersUsecase getAllCustomersUsecase;
  final FuelPumpEntity? selectedFuelPump;

  AllCustomersNotifier(
      {required this.getAllCustomersUsecase, required this.selectedFuelPump})
      : super(AllCustomersState.initial()) {
    fetchAllCustomers();
  }

  void fetchAllCustomers() async {
    state = AllCustomersState.loading();
    print("selectedFuelPump: ${selectedFuelPump?.id}");
    final result = await getAllCustomersUsecase.execute(
      fuelPumpId: selectedFuelPump?.id ?? '',
    );
    print("result: $result");
    if (result.isLeft()) {
      print(
          "Error fetching customers: ${result.fold((l) => l.message, (r) => 'Success')}");
    }
    result.fold(
      (failure) => state = AllCustomersState.error(failure.message),
      (customers) => state = AllCustomersState.loaded(customers),
    );
  }
}
