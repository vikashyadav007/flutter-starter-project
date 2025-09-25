import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/recent_transaction_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetRecentTransactionsUseCase {
  final DashboardRepository _repository;

  GetRecentTransactionsUseCase(this._repository);

  Future<Either<Failure, List<RecentTransactionEntity>>> execute({
    int limit = 3,
  }) async {
    return await _repository.getRecentTransactions(limit: limit);
  }
}