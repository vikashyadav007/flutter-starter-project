import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_data_entity.dart';

import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_sales_data_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/presentation/providers/dashboard_providers.dart';

part 'dashboard_analytics_provider.freezed.dart';

@freezed
class DashboardAnalyticsState with _$DashboardAnalyticsState {
  const factory DashboardAnalyticsState.initial() = _Initial;
  const factory DashboardAnalyticsState.loading() = _Loading;
  const factory DashboardAnalyticsState.loaded({
    required DashboardDataEntity dashboardData,
  }) = _Loaded;
  const factory DashboardAnalyticsState.error(Failure failure) = _Error;
}

final dashboardAnalyticsProvider =
    StateNotifierProvider<DashboardAnalyticsNotifier, DashboardAnalyticsState>(
        (ref) {
  final getSalesDataUseCase = ref.watch(getSalesDataUseCaseProvider);

  return DashboardAnalyticsNotifier(
    getSalesDataUseCase: getSalesDataUseCase,
  );
});

class DashboardAnalyticsNotifier
    extends StateNotifier<DashboardAnalyticsState> {
  final GetSalesDataUseCase _getSalesDataUseCase;

  DashboardAnalyticsNotifier({
    required GetSalesDataUseCase getSalesDataUseCase,
  })  : _getSalesDataUseCase = getSalesDataUseCase,
        super(const DashboardAnalyticsState.initial());

  Future<void> loadDashboardData(
      String period, Map<String, dynamic> customDateRange) async {
    state = const DashboardAnalyticsState.loading();

    try {
      final results = await Future.wait([
        _getSalesDataUseCase.execute(period, customDateRange),
      ]);

      state = results[0].fold(
        (failure) {
          return DashboardAnalyticsState.error(failure);
        },
        (dashboardData) {
          print('DashboardAnalyticsProvider: Successfully loaded data.');
          return DashboardAnalyticsState.loaded(dashboardData: dashboardData);
        },
      );
    } catch (e) {
      print('Unexpected error loading dashboard data: $e');
      state = DashboardAnalyticsState.error(
          Failure(message: 'Unexpected error occurred', code: 500));
    }
  }

  /// Refresh current data
  Future<void> refresh() async {
    final currentState = state;
    // if (currentState is _Loaded) {
    //   // If we have loaded data, refresh with the same date range
    //   // For simplicity, we'll refresh today's data
    //   await loadTodaysData();
    // } else {
    //   // Default to today's data
    //   await loadTodaysData();
    // }
  }
}
