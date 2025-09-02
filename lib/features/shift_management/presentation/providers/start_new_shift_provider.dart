import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_cart.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_nozzle_readings.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/staff_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_reading_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_shift_consumables_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_shift_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/create_new_shift_success_popup.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';

part 'start_new_shift_provider.freezed.dart';

@freezed
class StartNewShiftState with _$StartNewShiftState {
  const factory StartNewShiftState.initial() = _Initial;
  const factory StartNewShiftState.submitting() = _Submitting;
  const factory StartNewShiftState.submitted(bool success) = _Submitted;
  const factory StartNewShiftState.error(String message) = _Error;
}

final startNewShiftProvider =
    StateNotifierProvider<StartNewShiftNotifier, StartNewShiftState>((ref) {
  final createShiftUsecase = ref.read(createShiftUsecaseProvider);
  final createReadingUsecase = ref.read(createReadingUsecaseProvider);
  final createShiftConsumablesUsecase =
      ref.read(createShiftConsumablesUsecaseProvider);

  final staffEntity = ref.watch(selectedStaffProvider);
  final selectedPump = ref.watch(selectedPumpProvider);
  final startingCashAmount = ref.watch(startingCashAmountProvider);
  final pumpNozzleReadings = ref.watch(pumpNozzleReadingsProvider);
  final consumablesCart = ref.watch(consumablesCartProvider);

  final selectedFuelPump = ref.watch(selectedFuelPumpProvider);

  return StartNewShiftNotifier(
    createShiftUsecase: createShiftUsecase,
    createReadingUsecase: createReadingUsecase,
    createShiftConsumablesUsecase: createShiftConsumablesUsecase,
    staffEntity: staffEntity,
    selectedPump: selectedPump,
    startingCashAmount: startingCashAmount,
    pumpNozzleReadings: pumpNozzleReadings,
    consumablesCart: consumablesCart,
    selectedFuelPump: selectedFuelPump,
  );
});

class StartNewShiftNotifier extends StateNotifier<StartNewShiftState> {
  CreateShiftUsecase createShiftUsecase;
  CreateReadingUsecase createReadingUsecase;
  CreateShiftConsumablesUsecase createShiftConsumablesUsecase;

  StaffEntity? staffEntity;
  PumpSettingEntity? selectedPump;
  String startingCashAmount = '';
  List<PumpNozzleReadings> pumpNozzleReadings = [];
  List<ConsumablesCart> consumablesCart = [];

  FuelPumpEntity? selectedFuelPump;

  StartNewShiftNotifier(
      {required this.createShiftUsecase,
      required this.createReadingUsecase,
      required this.createShiftConsumablesUsecase,
      required this.staffEntity,
      required this.selectedPump,
      required this.startingCashAmount,
      required this.pumpNozzleReadings,
      required this.consumablesCart,
      required this.selectedFuelPump})
      : super(const StartNewShiftState.initial());

  Future<void> creaetNewShift() async {
    state = const StartNewShiftState.submitting();
    var body = {
      "staff_id": staffEntity?.id ?? "",
      "start_time": DateTime.now().toIso8601String(),
      "status": "active",
      "shift_type": "Day",
      if (startingCashAmount.isNotEmpty) "cash_remaining": startingCashAmount,
      "fuel_pump_id": selectedFuelPump?.id ?? "",
    };

    var result = await createShiftUsecase.execute(body: body);
    result.fold(
      (failure) => state = StartNewShiftState.error(failure.message),
      (shifts) async {
        if (shifts.isNotEmpty) {
          pumpNozzleReadings.forEach((reading) async {
            await createReadings(
                shiftId: shifts.first.id ?? "", reading: reading);
          });

          consumablesCart.forEach((consumable) async {
            await createShiftConsumables(
                shiftId: shifts.first.id ?? "", consumablesCart: consumable);
          });

          creaetNewShiftSuccessPopup();
        }
      },
    );
  }

  Future<void> createReadings(
      {required String shiftId, required PumpNozzleReadings reading}) async {
    state = const StartNewShiftState.submitting();
    var body = {
      "shift_id": shiftId,
      "staff_id": staffEntity?.id ?? "",
      "pump_id": selectedPump?.pumpNumber ?? "",
      "opening_reading": reading.currentReading ?? "",
      "date": DateTime.now().toIso8601String(),
      "fuel_type": reading.nozzle.fuelType,
      if (startingCashAmount.isNotEmpty) "cash_given": startingCashAmount,
      "fuel_pump_id": selectedFuelPump?.id ?? "",
    };

    var result = await createReadingUsecase.execute(body: body);
    result.fold(
      (failure) => state = StartNewShiftState.error(failure.message),
      (readings) {},
    );
  }

  Future<void> createShiftConsumables(
      {required String shiftId,
      required ConsumablesCart consumablesCart}) async {
    state = const StartNewShiftState.submitting();
    var body = {
      "shift_id": shiftId,
      "consumable_id": consumablesCart.consumables.id,
      "quantity_allocated": consumablesCart.quantity,
      "status": "allocated"
    };

    var result = await createShiftConsumablesUsecase.execute(body: body);
    result.fold(
      (failure) => state = StartNewShiftState.error(failure.message),
      (readings) {},
    );
  }
}
