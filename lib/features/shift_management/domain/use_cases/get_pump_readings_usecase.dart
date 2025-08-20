import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/reading_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetPumpReadingsUsecase {
  final ShiftManagementRepository _repository;

  GetPumpReadingsUsecase(this._repository);

  Future<Either<Failure, List<ReadingEntity>>> execute({
    required String fuelPumpId,
    required String pumpId,
  }) async {
    return await _repository.getPumpReadings(
        fuelPumpId: fuelPumpId, pumpId: pumpId);
  }
}
