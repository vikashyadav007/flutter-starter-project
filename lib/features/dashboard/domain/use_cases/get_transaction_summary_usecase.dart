import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/data/utils/dashboard_utils.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/transaction_summary_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetTransactionSummaryUseCase {
  final DashboardRepository _repository;

  GetTransactionSummaryUseCase(this._repository);

  Future<Either<Failure, TransactionSummaryEntity>> execute(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final startFormattedDate = DashboardUtils.formatDate(startDate);
    final endFormattedDate = DashboardUtils.formatDate(endDate);

    return await _repository.getTransactionSummaryForDateRange(
        startFormattedDate, endFormattedDate);
  }

  Future<Either<Failure, TransactionSummaryEntity>> executeToday() async {
    return await _repository.getTodaysTransactionSummary();
  }
}
