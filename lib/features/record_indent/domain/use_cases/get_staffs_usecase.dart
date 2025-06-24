import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/record_indent/domain/repositories/record_indent_repository.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';

class GetStaffsUsecase {
  final RecordIndentRepository _repository;

  GetStaffsUsecase(this._repository);

  Future<Either<Failure, List<StaffEntity>>> execute(
      {required String fuelPumpId}) async {
    return await _repository.getStaffs(fuelPumpId: fuelPumpId);
  }
}
