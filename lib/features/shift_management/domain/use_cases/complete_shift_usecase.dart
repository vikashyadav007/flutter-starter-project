import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class CompleteShiftUsecase {
  final ShiftManagementRepository _repository;

  CompleteShiftUsecase(this._repository);

  Future<Either<Failure, void>> execute(
      {required Map<String, dynamic> body, required String shiftId}) async {
    return await _repository.completeShift(
      body: body,
      shiftId: shiftId,
    );
  }
}
