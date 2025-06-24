import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/create_indent_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_indent_booklet_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_staffs_usecase.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_vehicle_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_fuel_type.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_indent_booklet.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';
import 'package:starter_project/shared/providers/selected_fuel_pump.dart';
import 'package:uuid/uuid.dart';

part 'submit_indent_provider.freezed.dart';

@freezed
class SubmitIndentState with _$SubmitIndentState {
  const factory SubmitIndentState.initial() = _Initial;
  const factory SubmitIndentState.submitting() = _Submitting;
  const factory SubmitIndentState.submitted(bool success) = _Submitted;
  const factory SubmitIndentState.error(String message) = _Error;
}

final submitIndentProvider =
    StateNotifierProvider<SubmitIndentNotifier, SubmitIndentState>((ref) {
  final getStaffsUsecase = ref.watch(getStaffsUsecaseProvider);
  final selectedPump = ref.watch(selectedFuelPumpProvider);
  final selectedCustomer = ref.watch(selectedCustomerProvider);
  final selectedVehicle = ref.watch(selectedCustomerVehicleProvider);
  final selectedFuelType = ref.watch(selectedFuelProvider);
  final selectedIndentBooklet = ref.watch(selectedIndentBookletProvider);
  final createIndentUsecase = ref.watch(createIndentUsecaseProvider);
  final getCustomerIndentUsecase = ref.watch(getCustomerIndentUsecaseProvider);

  return SubmitIndentNotifier(
    getStaffsUsecase: getStaffsUsecase,
    selectedFuelPump: selectedPump,
    selectedCustomer: selectedCustomer,
    selectedVehicle: selectedVehicle,
    selectedFuelType: selectedFuelType,
    selectedIndentBooklet: selectedIndentBooklet,
    createIndentUsecase: createIndentUsecase,
    getCustomerIndentUsecase: getCustomerIndentUsecase,
  );
});

class SubmitIndentNotifier extends StateNotifier<SubmitIndentState> {
  final GetStaffsUsecase getStaffsUsecase;
  final FuelPumpEntity? selectedFuelPump;
  final CustomerEntity? selectedCustomer;
  final VehicleEntity? selectedVehicle;
  final FuelEntity? selectedFuelType;
  final IndentBookletEntity? selectedIndentBooklet;
  final CreateIndentUsecase createIndentUsecase;
  final GetCustomerIndentUsecase getCustomerIndentUsecase;

  SubmitIndentNotifier({
    required this.getStaffsUsecase,
    required this.selectedFuelPump,
    required this.selectedCustomer,
    required this.selectedVehicle,
    required this.selectedFuelType,
    required this.selectedIndentBooklet,
    required this.createIndentUsecase,
    required this.getCustomerIndentUsecase,
  }) : super(const SubmitIndentState.initial());

  StaffEntity? staffEntity;
  String _quantity = "";
  String _amount = "";
  String _indentNumber = "";

  Future<void> submitIndent({
    required String amount,
    required String quantity,
    required String indentNumber,
  }) async {
    _amount = amount;
    _quantity = quantity;
    _indentNumber = indentNumber;
    state = const SubmitIndentState.submitting();
    final result =
        await getStaffsUsecase.execute(fuelPumpId: selectedFuelPump?.id ?? "");
    result.fold((failure) => state = SubmitIndentState.error(failure.message),
        (staffs) {
      if (staffs.isNotEmpty) {
        staffEntity = staffs.first;
        createNewIndent();
      } else {
        state = const SubmitIndentState.error("No staff available");
      }
    });
  }

  Future<void> createNewIndent() async {
    var indentId = new Uuid().v4();

    var body = {
      "id": indentId,
      "customer_id": selectedCustomer?.id ?? "",
      "vehicle_id": selectedVehicle?.id ?? "",
      "fuel_type": selectedFuelType?.fuelType ?? "",
      "amount": _amount,
      "quantity": _quantity,
      "discount_amount": 0,
      "indent_number": _indentNumber,
      "booklet_id": selectedIndentBooklet?.id ?? "",
      "date": DateTime.now().toIso8601String(),
      "status": "Pending Approval",
      "approval_status": "pending",
      "source": "mobile",
      "fuel_pump_id": selectedFuelPump?.id ?? "",
      "created_by_staff_id": staffEntity?.id ?? "",
    };

    var result = await createIndentUsecase.execute(body: body);
    result.fold(
      (failure) => state = SubmitIndentState.error(failure.message),
      (success) {
        state = SubmitIndentState.submitted(true);
      },
    );
  }
}
