import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_indent_booklet_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_vehicle_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_fuel_types_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_indent_booklets_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/verify_customer_indent_usecase.dart';
import 'package:starter_project/features/record_indent/presentation/providers/customer_indents_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/fuel_types_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/vehicles_list_provider.dart';
import 'package:starter_project/shared/providers/selected_fuel_pump.dart';

part 'record_indent_provider.freezed.dart';

@freezed
class RecordIndentState with _$RecordIndentState {
  const factory RecordIndentState.initial() = _Initial;
  const factory RecordIndentState.verifyingReocrdIndent() =
      _VerifyingReocrdIndent;
  const factory RecordIndentState.verifiedRecordIndents(bool verified) =
      _VerifiedRecordIndents;
  const factory RecordIndentState.error(Failure error) = _Error;
}

final recordIndentProvider =
    StateNotifierProvider<RecordIndentByNumberNotifier, RecordIndentState>(
        (ref) {
  final getIndentBookletsUsecase = ref.watch(getIndentBookletUsecaseProvider);
  final verifyCustomerIndentUsecase =
      ref.watch(verifyCustomerIndentUsecaseProvider);
  final selectedPump = ref.watch(selectedFuelPumpProvider);

  final getCustomerIndentUsecase = ref.watch(getCustomerIndentUsecaseProvider);

  final getCustomerVehicleUsecase =
      ref.watch(getCustomerVehicleUsecaseProvider);

  final getFuelTypesUsecase = ref.watch(getFuelTypesUsecaseProvider);

  final selectedCustomerNotifier = ref.watch(selectedCustomerProvider.notifier);

  final getCustomerUsecase = ref.watch(getCustomerUsecaseProvider);

  final customerIndentsNotifier = ref.watch(customerIndentProvider.notifier);

  final customerVehicleNotifier =
      ref.watch(customerVehicleListProvider.notifier);

  final fuelTypesNotifier = ref.watch(fuelTypesProvider.notifier);

  return RecordIndentByNumberNotifier(
    verifyCustomerIndentUsecase: verifyCustomerIndentUsecase,
    getIndentBookletsUsecase: getIndentBookletsUsecase,
    selectedFuelPump: selectedPump,
    getCustomerIndentUsecase: getCustomerIndentUsecase,
    getCustomerVehicleUsecase: getCustomerVehicleUsecase,
    getFuelTypesUsecase: getFuelTypesUsecase,
    selectedCustomerNotifier: selectedCustomerNotifier,
    getCustomerUsecase: getCustomerUsecase,
    customerIndentsNotifier: customerIndentsNotifier,
    customerVehicleNotifier: customerVehicleNotifier,
    fuelTypesNotifier: fuelTypesNotifier,
  );
});

class RecordIndentByNumberNotifier extends StateNotifier<RecordIndentState> {
  final VerifyCustomerIndentUsecase verifyCustomerIndentUsecase;
  final GetIndentBookletsUsecase getIndentBookletsUsecase;
  final FuelPumpEntity? selectedFuelPump;
  final GetCustomerIndentUsecase getCustomerIndentUsecase;
  final GetCustomerVehicleUsecase getCustomerVehicleUsecase;
  final GetFuelTypesUsecase getFuelTypesUsecase;
  final SelectedCustomerNotifier selectedCustomerNotifier;
  final GetCustomerUsecase getCustomerUsecase;

  final CustomerIndentsNotifier customerIndentsNotifier;
  final CustomerVehicleListNotifier customerVehicleNotifier;
  final FuelTypesNotifier fuelTypesNotifier;

  IndentBookletEntity? indentBookletEntity;

  RecordIndentByNumberNotifier({
    required this.verifyCustomerIndentUsecase,
    required this.getIndentBookletsUsecase,
    required this.selectedFuelPump,
    required this.getCustomerIndentUsecase,
    required this.getCustomerVehicleUsecase,
    required this.getFuelTypesUsecase,
    required this.getCustomerUsecase,
    required this.selectedCustomerNotifier,
    required this.customerIndentsNotifier,
    required this.customerVehicleNotifier,
    required this.fuelTypesNotifier,
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

  Future<void> verifyRecordIndent({required String indentNumber}) async {
    verifyingRecordIndent();

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
  }

  Future<void> handleIndentSearch({required List<IndentEntity> indents}) async {
    if (indents.isNotEmpty) {
      error(Failure(
          code: 1, message: "This indent number has already been used."));
    } else {
      final result1 = fetchCustomer();
      final result2 = fetchCustomerIndentBooklets();
      final result3 = fetchCustomerVehicles();
      final result4 = fetchFuelTypes();

      await Future.wait([result1, result2, result3, result4]);
      verifiedRecordIndents(true);
    }
  }

  Future<void> fetchCustomer() async {
    final result = await getCustomerUsecase.execute(
      customerId: indentBookletEntity?.customerId ?? "",
      fuelPumpId: selectedFuelPump?.id ?? "",
    );
    result.fold(
      (failure) => error(failure),
      (customers) {
        print("customers2121212: $customers");
        if (customers.isNotEmpty) {
          selectedCustomerNotifier.setCustomer(customers.first);
        } else {
          selectedCustomerNotifier.clearCustomer();
        }
      },
    );
  }

  Future<void> fetchCustomerIndentBooklets() async {
    final result = await getCustomerIndentUsecase.execute(
      customerId: indentBookletEntity?.customerId ?? "",
      fuelPumpId: selectedFuelPump?.id ?? "",
    );
    result.fold(
      (failure) => error(failure),
      (booklets) {
        print("customer bookeletsssss111111: $booklets");
        if (booklets.isNotEmpty) {
          customerIndentsNotifier.setCustomerBookletIndent(booklets);
        } else {
          customerIndentsNotifier.clearIndents();
        }
      },
    );
  }

  Future<void> fetchCustomerVehicles() async {
    final result = await getCustomerVehicleUsecase.execute(
      customerId: indentBookletEntity?.customerId ?? "",
      fuelPumpId: selectedFuelPump?.id ?? "",
    );
    result.fold(
      (failure) => error(failure),
      (vehicles) {
        print("vehicles90900909: $vehicles");
        if (vehicles.isNotEmpty) {
          customerVehicleNotifier.setVehicles(vehicles);
        } else {
          customerVehicleNotifier.clearVehicles();
        }
      },
    );
  }

  Future<void> fetchFuelTypes() async {
    final result = await getFuelTypesUsecase.execute(
      fuelPumpId: selectedFuelPump?.id ?? "",
    );
    result.fold(
      (failure) => error(failure),
      (fuels) {
        print("fuelssss bookeletsssss111111: $fuels");
        if (fuels.isNotEmpty) {
          fuelTypesNotifier.setFuels(fuels);
        } else {
          fuelTypesNotifier.clearFuels();
        }
      },
    );
  }

  void verifyingRecordIndent() {
    state = const RecordIndentState.verifyingReocrdIndent();
  }

  void verifiedRecordIndents(bool verified) {
    state = RecordIndentState.verifiedRecordIndents(verified);
  }

  void error(Failure error) {
    state = RecordIndentState.error(error);
  }
}
