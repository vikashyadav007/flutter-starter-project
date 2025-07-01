import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/shift_management/domain/entity/consumables_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/reading_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/shift_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';

abstract class ShiftManagementRepository {
  Future<Either<Failure, List<ShiftEntity>>> getShifts({
    required String fuelPumpId,
  });

  Future<Either<Failure, List<ReadingEntity>>> getReadings({
    required List<String> shiftIds,
  });

  Future<Either<Failure, List<StaffEntity>>> getStaffs({
    required String fuelPumpId,
  });
  Future<Either<Failure, List<PumpSettingEntity>>> getPumpSettings({
    required String fuelPumpId,
  });
  Future<Either<Failure, List<ConsumablesEntity>>> getConsumables({
    required String fuelPumpId,
  });
}
