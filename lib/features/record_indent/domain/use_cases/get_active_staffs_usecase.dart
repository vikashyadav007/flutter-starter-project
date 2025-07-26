import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/active_staff_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class GetActiveStaffsUsecase {
  final RecordIndentRepository _repository;

  GetActiveStaffsUsecase(this._repository);

  Future<Either<Failure, List<ActiveStaffEntity>>> execute(
      {required String fuelPumpId}) async {
    return await _repository.getActiveStaffs(fuelPumpId: fuelPumpId);
  }
}
