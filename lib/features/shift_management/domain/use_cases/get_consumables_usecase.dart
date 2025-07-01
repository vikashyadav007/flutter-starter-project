import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/shift_management/domain/entity/consumables_entity.dart';
import 'package:starter_project/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetConsumablesUsecase {
  final ShiftManagementRepository _repository;

  GetConsumablesUsecase(this._repository);

  Future<Either<Failure, List<ConsumablesEntity>>> execute({
    required String fuelPumpId,
  }) async {
    return await _repository.getConsumables(fuelPumpId: fuelPumpId);
  }
}
