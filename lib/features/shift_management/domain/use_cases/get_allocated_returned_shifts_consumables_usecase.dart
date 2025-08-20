import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_consumables_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetAllocatedReturnedShiftsConsumablesUsecase {
  final ShiftManagementRepository _repository;

  GetAllocatedReturnedShiftsConsumablesUsecase(this._repository);

  Future<Either<Failure, List<ShiftConsumablesEntity>>> execute({
    required String shiftId,
  }) async {
    return await _repository.getAllocatedReturnedShiftConsumables(
      shiftId: shiftId,
    );
  }
}
