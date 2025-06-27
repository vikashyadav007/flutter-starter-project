import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_fuel_type.dart';
import 'package:starter_project/features/shift_management/data/data_sources/shift_management_data_source.dart';
import 'package:starter_project/features/shift_management/data/respositories/shift_management_respository_impl.dart';
import 'package:starter_project/features/shift_management/domain/entity/reading_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/shift_entity.dart';
import 'package:starter_project/features/shift_management/domain/repositories/shift_management_repository.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/get_active_shifts_usecase.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/get_readings_usecase.dart';
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
    (banners) => banners,
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

// final readingsProvider = FutureProvider<List<ShiftEntity>>((ref) async {
//   final shifts =  ref.watch(shiftsProvider).value;
//   print("shifts: $shifts");

//   Map<String, ShiftEntity>? shiftsMap = {};

//   for (ShiftEntity shift in shifts ?? []) {
//     if (shift.id != null) {
//       shiftsMap[shift.id!] = shift;
//     }
//   }
//   print("shiftsMap: $shiftsMap");

//   List<String> shiftIds = shiftsMap.keys.toList();

//   print("shiftIds: $shiftIds");

//   final getReadingsUseCase = ref.watch(getReadinUseCaseProvider);

//   final result = await getReadingsUseCase.execute(shiftIds: shiftIds);

//   return result.fold(
//     (failure) => throw Exception(failure.message),
//     (readings) {
//       print("readings: $readings");
//       for (ReadingEntity reading in readings) {
//         if (reading.shiftId != null && shiftsMap.containsKey(reading.shiftId)) {
//           ShiftEntity? shift = shiftsMap[reading.shiftId];
//           shift = shift?.copyWith(
//             reading: reading,
//           );
//         }
//       }

//       return shifts ?? [];
//     },
//   );
// });
