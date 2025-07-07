import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class UpdateReadingUsecase {
  final ShiftManagementRepository _repository;

  UpdateReadingUsecase(this._repository);

  Future<Either<Failure, void>> execute(
      {required Map<String, dynamic> body,
      required String shiftId,
      required String fuelType}) async {
    return await _repository.updateReading(
      body: body,
      shiftId: shiftId,
      fuelType: fuelType,
    );
  }
}
