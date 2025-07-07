import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/reading_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_consumables_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/staff_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/transaction_entity.dart';

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

  Future<Either<Failure, List<ShiftEntity>>> createShift(
      {required Map<String, dynamic> body});

  Future<Either<Failure, List<ReadingEntity>>> createReading(
      {required Map<String, dynamic> body});

  Future<Either<Failure, void>> createShiftConsumables(
      {required Map<String, dynamic> body});

  Future<Either<Failure, List<ShiftConsumablesEntity>>> getShiftConsumables({
    required String shiftId,
  });

  Future<Either<Failure, List<TransactionEntity>>> getTransactions({
    required String staffId,
    required String createdAt,
  });

  Future<Either<Failure, void>> completeShift(
      {required Map<String, dynamic> body, required String shiftId});

  Future<Either<Failure, void>> updateReading(
      {required Map<String, dynamic> body,
      required String shiftId,
      required String fuelType});

  Future<Either<Failure, void>> reconilizeShiftConsumables({
    required Map<String, dynamic> body,
    required String id,
  });
}
