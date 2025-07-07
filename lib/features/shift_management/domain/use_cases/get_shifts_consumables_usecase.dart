import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_consumables_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetShiftsConsumablesUsecase {
  final ShiftManagementRepository _repository;

  GetShiftsConsumablesUsecase(this._repository);

  Future<Either<Failure, List<ShiftConsumablesEntity>>> execute({
    required String shiftId,
  }) async {
    return await _repository.getShiftConsumables(shiftId: shiftId);
  }
}
