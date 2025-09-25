import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/chart_data_point_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/fuel_volume_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_metrics_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/recent_transaction_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/transaction_summary_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<ChartDataPointEntity>>> getSalesData(
      String startDate, String endDate);

  Future<Either<Failure, List<FuelVolumeEntity>>> getFuelVolumeData(
      String startDate, String endDate);

  Future<Either<Failure, List<RecentTransactionEntity>>> getRecentTransactions(
      {int limit = 3});

  Future<Either<Failure, Map<String, double>>> getCurrentFuelLevels();

  Future<Either<Failure, DashboardMetricsEntity>> getDashboardMetrics(
      String startDate, String endDate);

  Future<Either<Failure, List<String>>> getConfiguredFuelTypes();

  Future<Either<Failure, TransactionSummaryEntity>>
      getTransactionSummaryForDateRange(String startDate, String endDate);

  Future<Either<Failure, TransactionSummaryEntity>>
      getTodaysTransactionSummary();

  Future<Either<Failure, Map<String, Map<String, String>>>>
      getTodaysFuelSalesBreakdown();
}
