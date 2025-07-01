import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/shift_management/domain/entity/reading_entity.dart';
import 'package:starter_project/features/shift_management/domain/repositories/shift_management_repository.dart';

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
