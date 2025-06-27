import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/shift_management/domain/entity/reading_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/shift_entity.dart';

abstract class ShiftManagementRepository {
  Future<Either<Failure, List<ShiftEntity>>> getShifts({
    required String fuelPumpId,
  });

  Future<Either<Failure, List<ReadingEntity>>> getReadings({
    required List<String> shiftIds,
  });
}
