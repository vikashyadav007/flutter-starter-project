import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_metrics_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardMetricsUseCase {
  final DashboardRepository _repository;

  GetDashboardMetricsUseCase(this._repository);

  Future<Either<Failure, DashboardMetricsEntity>> execute(
    String startDate,
    String endDate,
  ) async {
    return await _repository.getDashboardMetrics(startDate, endDate);
  }
}
