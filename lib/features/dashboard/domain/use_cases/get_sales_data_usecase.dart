import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_data_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetSalesDataUseCase {
  final DashboardRepository _repository;

  GetSalesDataUseCase(this._repository);

  Future<Either<Failure, DashboardDataEntity>> execute(
    String period,
    Map<String, dynamic> customDateRange,
  ) async {
    return await _repository.getSalesData(period, customDateRange);
  }
}
