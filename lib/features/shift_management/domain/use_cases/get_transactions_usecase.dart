import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/transaction_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetTransactionsUsecase {
  final ShiftManagementRepository _repository;

  GetTransactionsUsecase(this._repository);

  Future<Either<Failure, List<TransactionEntity>>> execute({
    required String shiftId,
  }) async {
    return await _repository.getTransactions(
      shiftId: shiftId,
    );
  }
}
