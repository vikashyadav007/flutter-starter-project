import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/shift_management/domain/entity/shift_entity.dart';
import 'package:starter_project/features/shift_management/domain/repositories/shift_management_repository.dart';

class CreateShiftUsecase {
  final ShiftManagementRepository _repository;

  CreateShiftUsecase(this._repository);

  Future<Either<Failure, List<ShiftEntity>>> execute(
      {required Map<String, dynamic> body}) async {
    return await _repository.createShift(
      body: body,
    );
  }
}
