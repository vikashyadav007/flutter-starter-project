import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_fuel_type.dart';
import 'package:starter_project/features/shift_management/data/data_sources/shift_management_data_source.dart';
import 'package:starter_project/features/shift_management/data/respositories/shift_management_respository_impl.dart';
import 'package:starter_project/features/shift_management/domain/entity/consumables_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/reading_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/shift_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';
import 'package:starter_project/features/shift_management/domain/repositories/shift_management_repository.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/get_active_shifts_usecase.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/get_consumables_usecase.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/get_pump_settings_usecase.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/get_readings_usecase.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/get_staffs_usecase.dart';
import 'package:starter_project/shared/providers/selected_fuel_pump.dart';

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

final shiftsProvider = FutureProvider<List<ShiftEntity>>((ref) async {
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
          shiftsMap[reading.shiftId!] = shift.copyWith(reading: reading);
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
