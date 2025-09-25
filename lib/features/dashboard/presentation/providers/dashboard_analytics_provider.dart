import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/data/utils/dashboard_utils.dart';

import 'package:fuel_pro_360/features/dashboard/domain/entities/chart_data_point_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/fuel_volume_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_metrics_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/recent_transaction_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/transaction_summary_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_sales_data_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_fuel_volume_data_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_dashboard_metrics_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_recent_transactions_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_transaction_summary_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_current_fuel_levels_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/presentation/providers/dashboard_providers.dart';

part 'dashboard_analytics_provider.freezed.dart';

@freezed
class DashboardAnalyticsState with _$DashboardAnalyticsState {
  const factory DashboardAnalyticsState.initial() = _Initial;
  const factory DashboardAnalyticsState.loading() = _Loading;
  const factory DashboardAnalyticsState.loaded({
    required List<ChartDataPointEntity> salesData,
    required List<FuelVolumeEntity> fuelVolumeData,
    required DashboardMetricsEntity metrics,
    required List<RecentTransactionEntity> recentTransactions,
    required TransactionSummaryEntity todaysSummary,
    required Map<String, double> fuelLevels,
  }) = _Loaded;
  const factory DashboardAnalyticsState.error(Failure failure) = _Error;
}

final dashboardAnalyticsProvider =
    StateNotifierProvider<DashboardAnalyticsNotifier, DashboardAnalyticsState>(
        (ref) {
  final getSalesDataUseCase = ref.watch(getSalesDataUseCaseProvider);
  final getFuelVolumeDataUseCase = ref.watch(getFuelVolumeDataUseCaseProvider);
  final getDashboardMetricsUseCase =
      ref.watch(getDashboardMetricsUseCaseProvider);
  final getRecentTransactionsUseCase =
      ref.watch(getRecentTransactionsUseCaseProvider);
  final getTransactionSummaryUseCase =
      ref.watch(getTransactionSummaryUseCaseProvider);
  final getCurrentFuelLevelsUseCase =
      ref.watch(getCurrentFuelLevelsUseCaseProvider);

  return DashboardAnalyticsNotifier(
    getSalesDataUseCase: getSalesDataUseCase,
    getFuelVolumeDataUseCase: getFuelVolumeDataUseCase,
    getDashboardMetricsUseCase: getDashboardMetricsUseCase,
    getRecentTransactionsUseCase: getRecentTransactionsUseCase,
    getTransactionSummaryUseCase: getTransactionSummaryUseCase,
    getCurrentFuelLevelsUseCase: getCurrentFuelLevelsUseCase,
  );
});

class DashboardAnalyticsNotifier
    extends StateNotifier<DashboardAnalyticsState> {
  final GetSalesDataUseCase _getSalesDataUseCase;
  final GetFuelVolumeDataUseCase _getFuelVolumeDataUseCase;
  final GetDashboardMetricsUseCase _getDashboardMetricsUseCase;
  final GetRecentTransactionsUseCase _getRecentTransactionsUseCase;
  final GetTransactionSummaryUseCase _getTransactionSummaryUseCase;
  final GetCurrentFuelLevelsUseCase _getCurrentFuelLevelsUseCase;

  DashboardAnalyticsNotifier({
    required GetSalesDataUseCase getSalesDataUseCase,
    required GetFuelVolumeDataUseCase getFuelVolumeDataUseCase,
    required GetDashboardMetricsUseCase getDashboardMetricsUseCase,
    required GetRecentTransactionsUseCase getRecentTransactionsUseCase,
    required GetTransactionSummaryUseCase getTransactionSummaryUseCase,
    required GetCurrentFuelLevelsUseCase getCurrentFuelLevelsUseCase,
  })  : _getSalesDataUseCase = getSalesDataUseCase,
        _getFuelVolumeDataUseCase = getFuelVolumeDataUseCase,
        _getDashboardMetricsUseCase = getDashboardMetricsUseCase,
        _getRecentTransactionsUseCase = getRecentTransactionsUseCase,
        _getTransactionSummaryUseCase = getTransactionSummaryUseCase,
        _getCurrentFuelLevelsUseCase = getCurrentFuelLevelsUseCase,
        super(const DashboardAnalyticsState.initial());

  /// Load all dashboard data for a date range
  Future<void> loadDashboardData(String startDate, String endDate) async {
    print(
        'DashboardAnalyticsProvider: Starting to load data for $startDate to $endDate');
    state = const DashboardAnalyticsState.loading();

    try {
      // Fetch all data concurrently
      print('DashboardAnalyticsProvider: Fetching data from all use cases...');
      final results = await Future.wait([
        _getSalesDataUseCase.execute(startDate, endDate),
        _getFuelVolumeDataUseCase.execute(startDate, endDate),
        _getDashboardMetricsUseCase.execute(startDate, endDate),
        _getRecentTransactionsUseCase.execute(limit: 5),
        _getTransactionSummaryUseCase.executeToday(),
        _getCurrentFuelLevelsUseCase.execute(),
      ]);

      print(
          'DashboardAnalyticsProvider: Received ${results.length} results from use cases');

      // Check for failures
      bool hasFailure = false;
      Failure? firstFailure;

      for (int i = 0; i < results.length; i++) {
        results[i].fold(
          (failure) {
            if (!hasFailure) {
              hasFailure = true;
              firstFailure = failure;
              print(
                  'Dashboard data loading failed at index $i: ${failure.message}');
            }
          },
          (success) {
            print(
                'Dashboard data loading succeeded at index $i with data type: ${success.runtimeType}');
          },
        );
      }

      if (hasFailure) {
        print('DashboardAnalyticsProvider: Setting error state due to failure');
        state = DashboardAnalyticsState.error(firstFailure!);
        return;
      }

      // If we got here, all requests succeeded
      final salesData = results[0].getOrElse(() => <ChartDataPointEntity>[])
          as List<ChartDataPointEntity>;
      final fuelVolumeData = results[1].getOrElse(() => <FuelVolumeEntity>[])
          as List<FuelVolumeEntity>;
      final metrics = results[2].getOrElse(() => const DashboardMetricsEntity(
            totalSales: '₹0',
            customers: '0',
            fuelVolume: '0 L',
            growth: '0%',
          )) as DashboardMetricsEntity;
      final recentTransactions =
          results[3].getOrElse(() => <RecentTransactionEntity>[])
              as List<RecentTransactionEntity>;
      final todaysSummary =
          results[4].getOrElse(() => const TransactionSummaryEntity(
                indentSales:
                    FuelTypeSalesEntity(volume: '0 L', amount: '₹0', count: 0),
                consumablesSales:
                    FuelTypeSalesEntity(volume: '0 L', amount: '₹0', count: 0),
                fuelTypeSales: {},
                total:
                    FuelTypeSalesEntity(volume: '0 L', amount: '₹0', count: 0),
              )) as TransactionSummaryEntity;
      final fuelLevels =
          results[5].getOrElse(() => <String, double>{}) as Map<String, double>;

      print('DashboardAnalyticsProvider: Successfully processed all data:');
      print('  - Sales data: ${salesData.length} items');
      print('  - Fuel volume data: ${fuelVolumeData.length} items');
      print('  - Metrics: ${metrics.totalSales}');
      print('  - Recent transactions: ${recentTransactions.length} items');
      print('  - Today\'s summary: ${todaysSummary.total.amount}');
      print('  - Fuel levels: ${fuelLevels.length} items');

      state = DashboardAnalyticsState.loaded(
        salesData: salesData,
        fuelVolumeData: fuelVolumeData,
        metrics: metrics,
        recentTransactions: recentTransactions,
        todaysSummary: todaysSummary,
        fuelLevels: fuelLevels,
      );

      print('DashboardAnalyticsProvider: Set state to loaded successfully');
    } catch (e) {
      print('Unexpected error loading dashboard data: $e');
      state = DashboardAnalyticsState.error(
          Failure(message: 'Unexpected error occurred', code: 500));
    }
  }

  /// Load only today's data
  Future<void> loadTodaysData() async {
    final today = DateTime.now();
    final todayFormattedDate = DashboardUtils.formatDate(today);
    await loadDashboardData(todayFormattedDate, todayFormattedDate);
  }

  /// Load data for the current month
  Future<void> loadCurrentMonthData() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    final startFormatted = DashboardUtils.formatDate(startOfMonth);
    final endFormatted = DashboardUtils.formatDate(endOfMonth);
    await loadDashboardData(startFormatted, endFormatted);
  }

  /// Refresh current data
  Future<void> refresh() async {
    final currentState = state;
    if (currentState is _Loaded) {
      // If we have loaded data, refresh with the same date range
      // For simplicity, we'll refresh today's data
      await loadTodaysData();
    } else {
      // Default to today's data
      await loadTodaysData();
    }
  }

  /// Load data for a custom date range
  Future<void> loadCustomDateRange(DateTime startDate, DateTime endDate) async {
    final startFormatted = DashboardUtils.formatDate(startDate);
    final endFormatted = DashboardUtils.formatDate(endDate);
    await loadDashboardData(startFormatted, endFormatted);
  }
}
