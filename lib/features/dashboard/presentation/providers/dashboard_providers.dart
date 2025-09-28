import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fuel_pro_360/features/dashboard/data/data_sources/dashboard_data_source.dart';
import 'package:fuel_pro_360/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:fuel_pro_360/features/dashboard/domain/use_cases/get_sales_data_usecase.dart';

// Data Source Provider
final dashboardDataSourceProvider = Provider<DashboardDataSource>((ref) {
  return DashboardDataSource(
    Supabase.instance.client,
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
