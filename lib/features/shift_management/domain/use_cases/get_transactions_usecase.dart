import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/shift_management/domain/entity/transaction_entity.dart';
import 'package:starter_project/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetTransactionsUsecase {
  final ShiftManagementRepository _repository;

  GetTransactionsUsecase(this._repository);

  Future<Either<Failure, List<TransactionEntity>>> execute({
    required String staffId,
    required String createdAt,
  }) async {
    return await _repository.getTransactions(
        staffId: staffId, createdAt: createdAt);
  }
}
