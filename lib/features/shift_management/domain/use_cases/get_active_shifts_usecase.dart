import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetActiveShiftsUsecase {
  final ShiftManagementRepository _repository;

  GetActiveShiftsUsecase(this._repository);

  Future<Either<Failure, List<ShiftEntity>>> execute({
    required String fuelPumpId,
  }) async {
    return await _repository.getShifts(fuelPumpId: fuelPumpId);
  }
}
