import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/reading_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetReadingsUsecase {
  final ShiftManagementRepository _repository;

  GetReadingsUsecase(this._repository);

  Future<Either<Failure, List<ReadingEntity>>> execute({
    required List<String> shiftIds,
  }) async {
    return await _repository.getReadings(shiftIds: shiftIds);
  }
}
