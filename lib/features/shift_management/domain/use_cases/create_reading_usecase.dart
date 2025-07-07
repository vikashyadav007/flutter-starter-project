import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/reading_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class CreateReadingUsecase {
  final ShiftManagementRepository _repository;

  CreateReadingUsecase(this._repository);

  Future<Either<Failure, List<ReadingEntity>>> execute(
      {required Map<String, dynamic> body}) async {
    return await _repository.createReading(
      body: body,
    );
  }
}
