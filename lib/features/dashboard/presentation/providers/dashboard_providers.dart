import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuel_pro_360/features/dashboard/data/data_sources/dashboard_data_source.dart';
import 'package:fuel_pro_360/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_sales_data_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_fuel_volume_data_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_dashboard_metrics_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_recent_transactions_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_transaction_summary_usecase.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_current_fuel_levels_usecase.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';

// Data Source Provider
final dashboardDataSourceProvider = Provider<DashboardDataSource>((ref) {
  final selectedFuelPump = ref.watch(selectedFuelPumpProvider);
  return DashboardDataSource(
    Supabase.instance.client,
    () => selectedFuelPump?.id,
  );
});

// Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepositoryImpl>((ref) {
  final dataSource = ref.watch(dashboardDataSourceProvider);
  return DashboardRepositoryImpl(dashboardDataSource: dataSource);
});

// Use Case Providers
final getSalesDataUseCaseProvider = Provider<GetSalesDataUseCase>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetSalesDataUseCase(repository);
});

final getFuelVolumeDataUseCaseProvider = Provider<GetFuelVolumeDataUseCase>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetFuelVolumeDataUseCase(repository);
});

final getDashboardMetricsUseCaseProvider = Provider<GetDashboardMetricsUseCase>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetDashboardMetricsUseCase(repository);
});

final getRecentTransactionsUseCaseProvider = Provider<GetRecentTransactionsUseCase>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetRecentTransactionsUseCase(repository);
});

final getTransactionSummaryUseCaseProvider = Provider<GetTransactionSummaryUseCase>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetTransactionSummaryUseCase(repository);
});

final getCurrentFuelLevelsUseCaseProvider = Provider<GetCurrentFuelLevelsUseCase>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetCurrentFuelLevelsUseCase(repository);
});