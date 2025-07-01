import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';
import 'package:starter_project/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetStaffsUsecase {
  final ShiftManagementRepository _repository;

  GetStaffsUsecase(this._repository);

  Future<Either<Failure, List<StaffEntity>>> execute({
    required String fuelPumpId,
  }) async {
    return await _repository.getStaffs(fuelPumpId: fuelPumpId);
  }
}
