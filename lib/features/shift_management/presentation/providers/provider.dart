import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/nozzle_setting_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_transaction_consumables_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_transaction_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_entity.dart';
import 'package:fuel_pro_360/features/shift_management/data/data_sources/shift_management_data_source.dart';
import 'package:fuel_pro_360/features/shift_management/data/respositories/shift_management_respository_impl.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_cart.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_reconciliation.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_closing_readings.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_nozzle_readings.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/reading_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_consumables_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/staff_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/transaction_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/complete_shift_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_reading_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_shift_consumables_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_shift_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_active_shifts_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_allocated_returned_shifts_consumables_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_consumables_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_indent_sales_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_nozzle_setting_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_pump_readings_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_pump_settings_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_readings_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_shifts_consumables_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_staffs_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/get_transactions_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/reconcilize_shift_consumables_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/update_reading_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/update_transaction_usecase.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';

final shiftManagementRepositoryProvider =
    Provider<ShiftManagementRepository>((ref) {
  final shiftManagementDataSource = ShiftManagementDataSource();
  return ShiftManagementRespositoryImpl(
      shiftManagementDataSource: shiftManagementDataSource);
});

final getActiveShiftsUsecaseProvider = Provider<GetActiveShiftsUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetActiveShiftsUsecase(shiftManagementRepository);
});

final getReadinUseCaseProvider = Provider<GetReadingsUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetReadingsUsecase(shiftManagementRepository);
});

final shiftsProvider =
    FutureProvider.autoDispose<List<ShiftEntity>>((ref) async {
  final getActiveShiftUseCase = ref.watch(getActiveShiftsUsecaseProvider);
  final fuelPump = ref.watch(selectedFuelPumpProvider);
  final result =
      await getActiveShiftUseCase.execute(fuelPumpId: fuelPump?.id ?? "");
  return result.fold(
    (failure) => throw Exception(failure.message),
    (shifts) {
      List<StaffEntity> activeStaffs = [];
      for (ShiftEntity shift in shifts) {
        if (shift.staff != null && !activeStaffs.contains(shift.staff)) {
          activeStaffs.add(shift.staff!);
        }
      }

      ref.read(staffOnActiveShifts.notifier).state = activeStaffs;

      return shifts;
    },
  );
});

final readingsProvider = FutureProvider<List<ShiftEntity>>((ref) async {
  final shifts = await ref.watch(shiftsProvider.future);
  print("shifts: $shifts");

  Map<String, ShiftEntity> shiftsMap = {
    for (final shift in shifts)
      if (shift.id != null) shift.id!: shift,
  };

  print("shiftsMap: $shiftsMap");

  List<String> shiftIds = shiftsMap.keys.toList();
  print("shiftIds: $shiftIds");

  final getReadingsUseCase = ref.watch(getReadinUseCaseProvider);
  final result = await getReadingsUseCase.execute(shiftIds: shiftIds);
  print('result: $result');

  return result.fold(
    (failure) {
      print("Error fetching readings: ${failure.message}");
      throw Exception(failure.message);
    },
    (readings) {
      print("readings: $readings");

      for (ReadingEntity reading in readings) {
        final shift = shiftsMap[reading.shiftId];
        if (shift != null) {
          shiftsMap[reading.shiftId!] =
              shift.copyWith(readings: [reading, ...shift.readings ?? []]);
        }
      }

      return shiftsMap.values.toList();
    },
  );
});

final getStaffUseCaseProvider = Provider<GetStaffsUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetStaffsUsecase(shiftManagementRepository);
});

final staffsProvider = FutureProvider<List<StaffEntity>>((ref) async {
  final getStaffUsecase = ref.watch(getStaffUseCaseProvider);
  final fuelPump = ref.watch(selectedFuelPumpProvider);
  final result = await getStaffUsecase.execute(fuelPumpId: fuelPump?.id ?? "");
  print("result from getStaffUsecase: $result");
  print("result: $result");
  return result.fold(
    (failure) => throw Exception(failure.message),
    (staffs) {
      final activeStaffs = ref.watch(staffOnActiveShifts);
      print("activeStaffs: $activeStaffs");
      if (activeStaffs.isNotEmpty) {
        return staffs.where((staff) => !activeStaffs.contains(staff)).toList();
      }
      return staffs;
    },
  );
});

final getConsumablesUseCaseProvider = Provider<GetConsumablesUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetConsumablesUsecase(shiftManagementRepository);
});

final consumablesProvider =
    FutureProvider<List<ConsumablesEntity>>((ref) async {
  final getConsumablesUsecase = ref.watch(getConsumablesUseCaseProvider);
  final fuelPump = ref.watch(selectedFuelPumpProvider);
  final result =
      await getConsumablesUsecase.execute(fuelPumpId: fuelPump?.id ?? "");
  return result.fold(
    (failure) => throw Exception(failure.message),
    (consumables) => consumables,
  );
});

final getPumpSettingsUsecaseProvider = Provider<GetPumpSettingsUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetPumpSettingsUsecase(shiftManagementRepository);
});

final pumpSettingsProvider =
    FutureProvider<List<PumpSettingEntity>>((ref) async {
  final getPumpSettingsUsecase = ref.watch(getPumpSettingsUsecaseProvider);
  final fuelPump = ref.watch(selectedFuelPumpProvider);
  final result =
      await getPumpSettingsUsecase.execute(fuelPumpId: fuelPump?.id ?? "");
  return result.fold(
    (failure) => throw Exception(failure.message),
    (pumpSettings) => pumpSettings,
  );
});

final selectedStaffProvider = StateProvider<StaffEntity?>((ref) => null);
final selectedPumpProvider = StateProvider<PumpSettingEntity?>((ref) => null);
final selectedConsumableProvider =
    StateProvider<ConsumablesEntity?>((ref) => null);

final staffOnActiveShifts = StateProvider<List<StaffEntity>>((ref) => []);

final consumablesCartProvider =
    StateProvider<List<ConsumablesCart>>((ref) => []);

final selectedQuantityProvider = StateProvider<String>((ref) => '1');

final startingCashAmountProvider = StateProvider<String>((ref) => '');

final pumpNozzleReadingsProvider =
    StateProvider<List<PumpNozzleReadings>>((ref) => []);

final createShiftUsecaseProvider = Provider<CreateShiftUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return CreateShiftUsecase(shiftManagementRepository);
});

final createReadingUsecaseProvider = Provider<CreateReadingUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return CreateReadingUsecase(shiftManagementRepository);
});

final createShiftConsumablesUsecaseProvider =
    Provider<CreateShiftConsumablesUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return CreateShiftConsumablesUsecase(shiftManagementRepository);
});

final selectedShiftProvider = StateProvider<ShiftEntity?>((ref) => null);

final pumpClosingReadingsProvider =
    StateProvider<List<PumpClosingReadings>>((ref) => []);

final endShiftReadingProvider =
    FutureProvider<List<PumpClosingReadings>>((ref) async {
  final getReadingsUsecase = ref.watch(getReadinUseCaseProvider);
  final shiftEntity = ref.watch(selectedShiftProvider);
  print("Selected Shift: ${shiftEntity?.id}");
  final result =
      await getReadingsUsecase.execute(shiftIds: [shiftEntity?.id ?? ""]);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (readings) {
      List<PumpClosingReadings> closingReadings = [];
      for (ReadingEntity reading in readings) {
        closingReadings.add(PumpClosingReadings(
          reading: reading,
          closingReading: '',
          totalLiters: '0.00',
          testingFuelReading: '',
        ));
      }
      ref.read(pumpClosingReadingsProvider.notifier).state = closingReadings;
      return closingReadings;
    },
  );
});

final cardSalesProvider = StateProvider<String>((ref) => '');
final upiSalesProvider = StateProvider<String>((ref) => '');
final cashSalesProvider = StateProvider<String>((ref) => '');
final otherSalesProvider = StateProvider<String>((ref) => '');
final indentSalesProvider = StateProvider<String>((ref) => '');

final getShiftsConsumablesUsecaseProvider =
    Provider<GetShiftsConsumablesUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetShiftsConsumablesUsecase(shiftManagementRepository);
});

final consumablesReconciliationProvider =
    StateProvider<List<ConsumablesReconciliation>>((ref) => []);

final shiftConsumablesProvider =
    FutureProvider<List<ConsumablesReconciliation>>((ref) async {
  final getShiftsConsumablesUsecase =
      ref.watch(getShiftsConsumablesUsecaseProvider);
  final shiftEntity = ref.watch(selectedShiftProvider);
  if (shiftEntity?.id == null) {
    return [];
  }
  final result =
      await getShiftsConsumablesUsecase.execute(shiftId: shiftEntity!.id!);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (consumables) {
      List<ConsumablesReconciliation> reconciliations = [];
      for (ShiftConsumablesEntity consumable in consumables) {
        reconciliations.add(ConsumablesReconciliation(
            shiftConsumables: consumable,
            returns: consumable.quantityAllocated.toString(),
            sold: 0,
            soldPrice: 0));
      }
      ref.read(consumablesReconciliationProvider.notifier).state =
          reconciliations;
      return reconciliations;
    },
  );
});

final otherExpensesProvider = StateProvider<String>((ref) => '');
final cashCountProvider = StateProvider<String>((ref) => '');

final getTransactionsUsecaseProvider = Provider<GetTransactionsUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetTransactionsUsecase(shiftManagementRepository);
});

final shiftTransactionsProvider = FutureProvider<double>((ref) async {
  final getTransactionsUsecase = ref.watch(getTransactionsUsecaseProvider);
  final shiftEntity = ref.watch(selectedShiftProvider);
  if (shiftEntity?.id == null) {
    return 0.0;
  }
  final result = await getTransactionsUsecase.execute(
    shiftId: shiftEntity?.id ?? "",
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (transactions) {
      double total = 0;
      for (TransactionEntity transaction in transactions) {
        if (transaction.amount != null &&
            transaction.paymentMethod == "indent") {
          total += transaction.amount!;
        }
      }
      return total;
    },
  );
});

final indentSalesUsecaseProvider = Provider<GetIndentSalesUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetIndentSalesUsecase(shiftManagementRepository);
});

final shiftIndentSalesProvider = FutureProvider<double>((ref) async {
  final getIndentSalesUsecase = ref.watch(indentSalesUsecaseProvider);
  final shiftEntity = ref.watch(selectedShiftProvider);
  if (shiftEntity?.id == null) {
    return 0.0;
  }
  final result = await getIndentSalesUsecase.execute(
    shiftId: shiftEntity!.id!,
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (indents) {
      double total = 0;
      for (IndentEntity indent in indents) {
        if (indent.amount != null) {
          total += indent.amount!;
        }
      }
      return total;
    },
  );
});

//It will be sum of transactionsProvide and indentSalesProvider
final totalIndentSalesProvider = FutureProvider<double>((ref) async {
  final transactions = await ref.watch(shiftTransactionsProvider.future);
  final indentSales = await ref.watch(shiftIndentSalesProvider.future);
  final totalSales = transactions + indentSales;
  ref.read(indentSalesProvider.notifier).state = totalSales.toStringAsFixed(2);
  return totalSales;
});

final completeShiftUsecaseProvider = Provider<CompleteShiftUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return CompleteShiftUsecase(shiftManagementRepository);
});

final reconcilizeShiftConsumablesUsecaseProvider =
    Provider<ReconcilizeShiftConsumablesUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return ReconcilizeShiftConsumablesUsecase(shiftManagementRepository);
});

final updateReadingUsecaseProvider = Provider<UpdateReadingUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return UpdateReadingUsecase(shiftManagementRepository);
});

final totalConsumablesSoldProvider = Provider<double>((ref) {
  final consumablesReconciliation =
      ref.watch(consumablesReconciliationProvider);
  double total = 0;
  for (var consumable in consumablesReconciliation) {
    total += (consumable.soldPrice ?? 0);
  }
  return total;
});

final createTransactionUsecaseProviderShiftManagement =
    Provider<CreateTransactionUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return CreateTransactionUsecase(shiftManagementRepository);
});

final createTransactionConsumablesUsecaseProvider =
    Provider<CreateTransactionConsumablesUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return CreateTransactionConsumablesUsecase(shiftManagementRepository);
});

final updateTransactionUsecaseProvider =
    Provider<UpdateTransactionUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return UpdateTransactionUsecase(shiftManagementRepository);
});

final getPumpReadingsUseCaseProvider = Provider<GetPumpReadingsUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetPumpReadingsUsecase(shiftManagementRepository);
});

final getAllocatedReturnedShiftsConsumablesUsecaseProvider =
    Provider<GetAllocatedReturnedShiftsConsumablesUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetAllocatedReturnedShiftsConsumablesUsecase(
      shiftManagementRepository);
});

final pumpReadingProvider = FutureProvider<List<ReadingEntity>>((ref) async {
  print("pump Reading provider is called");
  final getPumpReadingsUseCase = ref.watch(getPumpReadingsUseCaseProvider);
  final fuelPump = ref.watch(selectedFuelPumpProvider);
  final pump = ref.watch(selectedPumpProvider);

  if (fuelPump == null || pump == null) {
    return [];
  }
  final result = await getPumpReadingsUseCase.execute(
    fuelPumpId: fuelPump.id,
    pumpId: pump.pumpNumber ?? "",
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (readings) => readings,
  );
});

final getNozzleSettingUsecaseProvider =
    Provider<GetNozzleSettingUsecase>((ref) {
  final shiftManagementRepository =
      ref.watch(shiftManagementRepositoryProvider);
  return GetNozzleSettingUsecase(shiftManagementRepository);
});

final nozzleSettingsProvider =
    FutureProvider<List<NozzleSettingEntity>>((ref) async {
  final getNozzleSettingUsecase = ref.watch(getNozzleSettingUsecaseProvider);
  final pump = ref.watch(selectedPumpProvider);
  final fuelPump = ref.watch(selectedFuelPumpProvider);

  if (pump == null) return [];

  final result = await getNozzleSettingUsecase.execute(
    fuelPumpId: fuelPump?.id ?? "",
    pumpId: pump?.id ?? "",
  );
  return result.fold(
    (failure) => throw Exception(failure.message),
    (nozzleSettings) => nozzleSettings,
  );
});

final lastClosedShiftIdForPumpProvider = StateProvider<String?>((ref) => null);

final preFillSelectedPumpReadingsListener = Provider<void>((ref) {
  final pump = ref.watch(selectedPumpProvider);
  final nozzleSettingState = ref.watch(nozzleSettingsProvider);
  print("preFillSelectedPumpReadingsListener called");

  if (pump == null) return;

  nozzleSettingState.when(
    data: (nozzles) {
      print("nozzles.isEmpty: ${nozzles.isEmpty}");
      if (nozzles.isEmpty) {
        ref.listen<AsyncValue<List<ReadingEntity>>>(pumpReadingProvider,
            (prev, next) {
          next.whenData((pumpReadings) {
            List<PumpNozzleReadings> pumpNozzleReadings = [];

            for (String fuelType in pump.fuelTypes) {
              if (pumpReadings.isEmpty) {
                pumpNozzleReadings.add(PumpNozzleReadings(
                  nozzle: NozzleSettingEntity(fuelType: fuelType),
                  currentReading: '',
                ));
              } else {
                ref.read(lastClosedShiftIdForPumpProvider.notifier).state =
                    pumpReadings[0].shiftId;

                for (ReadingEntity pumpReading in pumpReadings) {
                  if (pumpReading.fuelType == fuelType) {
                    pumpNozzleReadings.add(PumpNozzleReadings(
                      nozzle: NozzleSettingEntity(fuelType: fuelType),
                      currentReading: pumpReading.closingReading.toString(),
                    ));
                    break;
                  }
                }
              }
            }

            ref.read(pumpNozzleReadingsProvider.notifier).state =
                pumpNozzleReadings;
          });
        });
      } else {
        ref.listen<AsyncValue<List<ReadingEntity>>>(pumpReadingProvider,
            (prev, next) {
          print("this comes herererer");
          next.whenData((pumpReadings) {
            print("pumpReadings.isEmpty: ${pumpReadings.isEmpty}");
            List<PumpNozzleReadings> pumpNozzleReadings = [];

            for (NozzleSettingEntity nozzle in nozzles) {
              if (pumpReadings.isEmpty) {
                pumpNozzleReadings.add(PumpNozzleReadings(
                  nozzle: nozzle,
                  currentReading: '',
                ));
              } else {
                ref.read(lastClosedShiftIdForPumpProvider.notifier).state =
                    pumpReadings[0].shiftId;
                for (ReadingEntity pumpReading in pumpReadings) {
                  if (pumpReading.nozzleNumber == nozzle.nozzleNumber) {
                    pumpNozzleReadings.add(PumpNozzleReadings(
                      nozzle: nozzle,
                      currentReading: pumpReading.closingReading.toString(),
                    ));
                    break;
                  }
                }
              }
            }

            // Update the entire state here (allowed inside listener)
            ref.read(pumpNozzleReadingsProvider.notifier).state =
                pumpNozzleReadings;
          });
        });
      }
    },
    error: (Object error, StackTrace stackTrace) {},
    loading: () {},
  );
});

final autoAdjustShiftConsumablesListener = FutureProvider<void>((ref) async {
  print("autoAdjustShiftConsumablesListener");
  final getAllocatedReturnedShiftsConsumablesUsecase =
      ref.watch(getAllocatedReturnedShiftsConsumablesUsecaseProvider);

  final lastClosedShiftIdForPump = ref.watch(lastClosedShiftIdForPumpProvider);

  if (lastClosedShiftIdForPump == null) return;

  final result = await getAllocatedReturnedShiftsConsumablesUsecase.execute(
      shiftId: lastClosedShiftIdForPump ?? "");

  result.fold((failure) => throw Exception(failure.message),
      (shiftConsumables) {
    if (shiftConsumables.isEmpty) return;
    List<ConsumablesCart> consumablesCarts = [];
    for (ShiftConsumablesEntity shiftConsumable in shiftConsumables) {
      consumablesCarts.add(
        ConsumablesCart(
          consumables: shiftConsumable.consumables ?? ConsumablesEntity(),
          quantity: shiftConsumable.quantityReturned,
        ),
      );
    }

    ref.read(consumablesCartProvider.notifier).state = consumablesCarts;
  });
});
