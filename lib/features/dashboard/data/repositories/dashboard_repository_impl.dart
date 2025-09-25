import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/error_handler.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/data/data_sources/dashboard_data_source.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/chart_data_point_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/fuel_volume_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_metrics_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/recent_transaction_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/transaction_summary_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardDataSource _dashboardDataSource;

  DashboardRepositoryImpl({required DashboardDataSource dashboardDataSource})
      : _dashboardDataSource = dashboardDataSource;

  @override
  Future<Either<Failure, List<ChartDataPointEntity>>> getSalesData(
      String startDate, String endDate) async {
    try {
      // Convert formatted date strings back to DateTime for data source
      final startDateTime = DateTime.parse(startDate);
      final endDateTime = DateTime.parse(endDate);
      final salesData =
          await _dashboardDataSource.getSalesData(startDateTime, endDateTime);
      return Right(salesData.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<FuelVolumeEntity>>> getFuelVolumeData(
      String startDate, String endDate) async {
    try {
      // Convert formatted date strings back to DateTime for data source
      final startDateTime = DateTime.parse(startDate);
      final endDateTime = DateTime.parse(endDate);
      final volumeData = await _dashboardDataSource.getFuelVolumeData(
          startDateTime, endDateTime);
      return Right(volumeData.map((model) => model.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<RecentTransactionEntity>>> getRecentTransactions(
      {int limit = 3}) async {
    try {
      final transactionsData =
          await _dashboardDataSource.getRecentTransactions(limit: limit);
      final transactions = transactionsData
          .map((data) => RecentTransactionEntity(
                id: data['id'] as String,
                fuelType: data['fuel_type'] as String,
                amount: (data['amount'] as num).toDouble(),
                createdAt: DateTime.parse(data['created_at'] as String),
                quantity: (data['quantity'] as num).toDouble(),
              ))
          .toList();
      return Right(transactions);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getCurrentFuelLevels() async {
    try {
      final fuelLevels = await _dashboardDataSource.getCurrentFuelLevels();
      return Right(fuelLevels);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<String>>> getConfiguredFuelTypes() async {
    try {
      final fuelTypes = await _dashboardDataSource.getConfiguredFuelTypes();
      return Right(fuelTypes);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, DashboardMetricsEntity>> getDashboardMetrics(
      String startDate, String endDate) async {
    try {
      // Convert formatted date strings back to DateTime for data source
      final startDateTime = DateTime.parse(startDate);
      final endDateTime = DateTime.parse(endDate);
      final metricsData = await _dashboardDataSource.getDashboardMetrics(
          startDateTime, endDateTime);
      return Right(metricsData.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, TransactionSummaryEntity>>
      getTransactionSummaryForDateRange(
          String startDate, String endDate) async {
    try {
      // Convert formatted date strings back to DateTime for data source
      final startDateTime = DateTime.parse(startDate);
      final endDateTime = DateTime.parse(endDate);
      final summaryData = await _dashboardDataSource
          .getTransactionSummaryForDateRange(startDateTime, endDateTime);

      return Right(TransactionSummaryEntity(
        indentSales: FuelTypeSalesEntity(
          volume: summaryData['indentSales']['volume'],
          amount: summaryData['indentSales']['amount'],
          count: summaryData['indentSales']['count'],
        ),
        consumablesSales: FuelTypeSalesEntity(
          volume: summaryData['consumablesSales']['volume'],
          amount: summaryData['consumablesSales']['amount'],
          count: summaryData['consumablesSales']['count'],
        ),
        fuelTypeSales:
            (summaryData['fuelTypeSales'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            FuelTypeSalesEntity(
              volume: value['volume'],
              amount: value['amount'],
              count: value['count'],
            ),
          ),
        ),
        total: FuelTypeSalesEntity(
          volume: summaryData['total']['volume'],
          amount: summaryData['total']['amount'],
          count: summaryData['total']['count'],
        ),
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, TransactionSummaryEntity>>
      getTodaysTransactionSummary() async {
    try {
      final today = DateTime.now();
      final summaryData = await _dashboardDataSource
          .getTransactionSummaryForDateRange(today, today);

      return Right(TransactionSummaryEntity(
        indentSales: FuelTypeSalesEntity(
          volume: summaryData['indentSales']['volume'],
          amount: summaryData['indentSales']['amount'],
          count: summaryData['indentSales']['count'],
        ),
        consumablesSales: FuelTypeSalesEntity(
          volume: summaryData['consumablesSales']['volume'],
          amount: summaryData['consumablesSales']['amount'],
          count: summaryData['consumablesSales']['count'],
        ),
        fuelTypeSales:
            (summaryData['fuelTypeSales'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            FuelTypeSalesEntity(
              volume: value['volume'],
              amount: value['amount'],
              count: value['count'],
            ),
          ),
        ),
        total: FuelTypeSalesEntity(
          volume: summaryData['total']['volume'],
          amount: summaryData['total']['amount'],
          count: summaryData['total']['count'],
        ),
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, Map<String, Map<String, String>>>>
      getTodaysFuelSalesBreakdown() async {
    try {
      final breakdown =
          await _dashboardDataSource.getTodaysFuelSalesBreakdown();
      return Right(breakdown);
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
