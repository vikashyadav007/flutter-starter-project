import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class UpdateTransactionUsecase {
  final ShiftManagementRepository _repository;

  UpdateTransactionUsecase(this._repository);

  Future<Either<Failure, void>> execute({
    required Map<String, dynamic> body,
    required String shiftConsumableId,
  }) async {
    return await _repository.updateTransaction(
      body: body,
      shiftConsumableId: shiftConsumableId,
    );
  }
}
