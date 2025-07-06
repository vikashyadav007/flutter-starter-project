import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/shift_management/domain/repositories/shift_management_repository.dart';

class ReconcilizeShiftConsumablesUsecase {
  final ShiftManagementRepository _repository;

  ReconcilizeShiftConsumablesUsecase(this._repository);

  Future<Either<Failure, void>> execute({
    required Map<String, dynamic> body,
    required String id,
  }) async {
    return await _repository.reconilizeShiftConsumables(
      body: body,
      id: id,
    );
  }
}
