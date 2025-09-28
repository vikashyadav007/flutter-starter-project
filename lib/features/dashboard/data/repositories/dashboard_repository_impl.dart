import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/error_handler.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/data/data_sources/dashboard_data_source.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_data_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final DashboardDataSource _dashboardDataSource;

  DashboardRepositoryImpl({required DashboardDataSource dashboardDataSource})
      : _dashboardDataSource = dashboardDataSource;

  @override
  Future<Either<Failure, DashboardDataEntity>> getSalesData(
      String period, Map<String, dynamic> dateRange) async {
    try {
      final dashboardData =
          await _dashboardDataSource.getSalesData(period, dateRange);
      return Right(dashboardData.toEntity());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
