import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/chart_data_point_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetSalesDataUseCase {
  final DashboardRepository _repository;

  GetSalesDataUseCase(this._repository);

  Future<Either<Failure, List<ChartDataPointEntity>>> execute(
    String startDate,
    String endDate,
  ) async {
    return await _repository.getSalesData(startDate, endDate);
  }
}
