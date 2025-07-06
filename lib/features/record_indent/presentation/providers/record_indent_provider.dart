import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_indent_booklet_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_vehicle_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_fuel_types_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_indent_booklets_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/verify_customer_indent_usecase.dart';
import 'package:starter_project/features/record_indent/presentation/providers/customer_indents_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_vehicle_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_indent_booklet.dart';
import 'package:starter_project/features/record_indent/presentation/providers/vehicles_list_provider.dart';
import 'package:starter_project/shared/providers/selected_fuel_pump.dart';

part 'record_indent_provider.freezed.dart';

@freezed
class RecordIndentState with _$RecordIndentState {
  const factory RecordIndentState.initial() = _Initial;
  const factory RecordIndentState.loading() = _LoadingRecordIndentState;
  const factory RecordIndentState.verifiedRecordIndents(bool verified) =
      _VerifiedRecordIndents;
  const factory RecordIndentState.customerSelected(bool selected) =
      _CustomerSelected;
  const factory RecordIndentState.error(Failure error) = _Error;
}

final recordIndentProvider =
    StateNotifierProvider<RecordIndentNotifier, RecordIndentState>((ref) {
  final getIndentBookletsUsecase = ref.watch(getIndentBookletUsecaseProvider);
  final verifyCustomerIndentUsecase =
      ref.watch(verifyCustomerIndentUsecaseProvider);
  final selectedPump = ref.watch(selectedFuelPumpProvider);

  final getCustomerIndentUsecase = ref.watch(getCustomerIndentUsecaseProvider);

  final getCustomerVehicleUsecase =
      ref.watch(getCustomerVehicleUsecaseProvider);

  final selectedCustomerNotifier = ref.watch(selectedCustomerProvider.notifier);

  final getCustomerUsecase = ref.watch(getCustomerUsecaseProvider);

  final customerIndentsNotifier = ref.watch(customerIndentProvider.notifier);

  final customerVehicleNotifier =
      ref.watch(customerVehicleListProvider.notifier);

  final selectedCustomerVehicleNotifier =
      ref.watch(selectedCustomerVehicleProvider.notifier);

  final selectedIndentBookletNotifier =
      ref.watch(selectedIndentBookletProvider.notifier);

  final selectedFuelPumpNotifier = ref.watch(selectedFuelPumpProvider.notifier);

  return RecordIndentNotifier(
    verifyCustomerIndentUsecase: verifyCustomerIndentUsecase,
    getIndentBookletsUsecase: getIndentBookletsUsecase,
    selectedFuelPump: selectedPump,
    getCustomerIndentUsecase: getCustomerIndentUsecase,
    getCustomerVehicleUsecase: getCustomerVehicleUsecase,
    selectedCustomerNotifier: selectedCustomerNotifier,
    getCustomerUsecase: getCustomerUsecase,
    customerIndentsNotifier: customerIndentsNotifier,
    customerVehicleNotifier: customerVehicleNotifier,
    selectedCustomerVehicleNotifier: selectedCustomerVehicleNotifier,
    selectedIndentBookletNotifier: selectedIndentBookletNotifier,
    selectedFuelPumpNotifier: selectedFuelPumpNotifier,
  );
});

class RecordIndentNotifier extends StateNotifier<RecordIndentState> {
  final VerifyCustomerIndentUsecase verifyCustomerIndentUsecase;
  final GetIndentBookletsUsecase getIndentBookletsUsecase;
  final FuelPumpEntity? selectedFuelPump;
  final GetCustomerIndentUsecase getCustomerIndentUsecase;
  final GetCustomerVehicleUsecase getCustomerVehicleUsecase;
  final SelectedCustomerNotifier selectedCustomerNotifier;
  final GetCustomerUsecase getCustomerUsecase;

  final CustomerIndentsNotifier customerIndentsNotifier;
  final CustomerVehicleListNotifier customerVehicleNotifier;

  IndentBookletEntity? indentBookletEntity;

  SelectedCustomerVehicleNotifier selectedCustomerVehicleNotifier;
  SelectedIndentBookletNotifier selectedIndentBookletNotifier;
  SelectedFuelPumpNotifier selectedFuelPumpNotifier;

  RecordIndentNotifier({
    required this.verifyCustomerIndentUsecase,
    required this.getIndentBookletsUsecase,
    required this.selectedFuelPump,
    required this.getCustomerIndentUsecase,
    required this.getCustomerVehicleUsecase,
    required this.getCustomerUsecase,
    required this.selectedCustomerNotifier,
    required this.customerIndentsNotifier,
    required this.customerVehicleNotifier,
    required this.selectedCustomerVehicleNotifier,
    required this.selectedIndentBookletNotifier,
    required this.selectedFuelPumpNotifier,
  }) : super(const RecordIndentState.initial());

  Future<List<IndentBookletEntity>> getAllIndentBooklets() async {
    if (selectedFuelPump == null) return [];
    final result = await getIndentBookletsUsecase.execute(
      fuelPumpId: selectedFuelPump!.id,
    );
    return result.fold(
      (failure) => [],
      (booklets) => booklets,
    );
  }

  Future<void> verifyRecordIndent(
      {required String indentNumber, required int selectedTabIndex}) async {
    print(
        "this one called againnnnnnnnnnnnnnnnnnnn with indent number: $indentNumber");
    if (selectedTabIndex == 0) {
      loading();

      List<IndentBookletEntity> booklets = await getAllIndentBooklets();

      for (IndentBookletEntity booklet in booklets) {
        if (int.parse(indentNumber) >= int.parse(booklet.startNumber ?? "0") &&
            int.parse(indentNumber) <= int.parse(booklet.endNumber ?? "0")) {
          indentBookletEntity = booklet;
          break;
        }
      }

      if (indentBookletEntity != null) {
        final result = await verifyCustomerIndentUsecase.execute(
          indentNumber: indentNumber.toString(),
          bookletId: indentBookletEntity?.id ?? "",
        );

        result.fold(
          (failure) => error(failure),
          (indentList) {
            handleIndentSearch(indents: indentList);
          },
        );
      }
    } else {
      loading();
      IndentBookletEntity? indentBookletEntity =
          selectedIndentBookletNotifier.indentBooklet;

      if (!(int.parse(indentNumber) >=
              int.parse(indentBookletEntity?.startNumber ?? "0") &&
          int.parse(indentNumber) <=
              int.parse(indentBookletEntity?.endNumber ?? "0"))) {
        error(Failure(
            code: 1,
            message: "This indent number not belongs to this booklet."));
      }
      final result = await verifyCustomerIndentUsecase.execute(
        indentNumber: indentNumber.toString(),
        bookletId: indentBookletEntity?.id ?? "",
      );
      print("verifyCustomerIndentUsecase result: $result");
      print(result);
      result.fold(
        (failure) => error(failure),
        (indentList) {
          if (indentList.isNotEmpty) {
            error(Failure(
                code: 1, message: "This indent number has already been used."));
          } else {
            state = RecordIndentState.verifiedRecordIndents(true);
          }
        },
      );
    }
  }

  Future<void> handleIndentSearch({required List<IndentEntity> indents}) async {
    if (indents.isNotEmpty) {
      error(Failure(
          code: 1, message: "This indent number has already been used."));
    } else {
      final result1 = fetchCustomer();
      final result2 = fetchAllData(
        customerId: indentBookletEntity?.customerId ?? "",
      );

      await Future.wait([result1, result2]);

      verifiedRecordIndents(true);
    }
  }

  Future<void> handleCustomerSelect(CustomerEntity customerEntity) async {
    await fetchAllData(
      customerId: customerEntity.id ?? "",
    );
    customerSelected(true);
  }

  Future<void> fetchAllData({
    required String customerId,
  }) async {
    final result2 = fetchCustomerIndentBooklets(
      customerId: customerId,
    );
    final result3 = fetchCustomerVehicles(customerId: customerId);

    await Future.wait([result2, result3]);
    verifiedRecordIndents(true);
  }

  Future<void> fetchCustomer() async {
    final result = await getCustomerUsecase.execute(
      customerId: indentBookletEntity?.customerId ?? "",
      fuelPumpId: selectedFuelPump?.id ?? "",
    );
    result.fold(
      (failure) => error(failure),
      (customers) {
        if (customers.isNotEmpty) {
          selectedCustomerNotifier.setCustomer(customers.first);
        } else {
          selectedCustomerNotifier.clearCustomer();
        }
      },
    );
  }

  Future<void> fetchCustomerIndentBooklets({required String customerId}) async {
    final result = await getCustomerIndentUsecase.execute(
      customerId: customerId,
      fuelPumpId: selectedFuelPump?.id ?? "",
    );
    result.fold(
      (failure) => error(failure),
      (booklets) {
        if (booklets.isNotEmpty) {
          customerIndentsNotifier.setCustomerBookletIndent(booklets);
        } else {
          customerIndentsNotifier.clearIndents();
        }
      },
    );
  }

  Future<void> fetchCustomerVehicles({required String customerId}) async {
    final result = await getCustomerVehicleUsecase.execute(
      customerId: customerId,
      fuelPumpId: selectedFuelPump?.id ?? "",
    );
    result.fold(
      (failure) => error(failure),
      (vehicles) {
        if (vehicles.isNotEmpty) {
          customerVehicleNotifier.setVehicles(vehicles);
        } else {
          customerVehicleNotifier.clearVehicles();
        }
      },
    );
  }

  void loading() {
    state = const RecordIndentState.loading();
  }

  void verifiedRecordIndents(bool verified) {
    state = RecordIndentState.verifiedRecordIndents(verified);
  }

  void customerSelected(bool selected) {
    state = RecordIndentState.customerSelected(selected);
  }

  void error(Failure error) {
    state = RecordIndentState.error(error);
  }

  void clearAll() {
    customerVehicleNotifier.clearVehicles();
    customerIndentsNotifier.clearIndents();
    selectedCustomerNotifier.clearCustomer();
    selectedCustomerVehicleNotifier.clearVehicle();
    selectedIndentBookletNotifier.clearIndentBooklet();

    indentBookletEntity = null;
    state = const RecordIndentState.initial();
  }
}
