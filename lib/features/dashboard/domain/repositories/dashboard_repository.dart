import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_data_entity.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardDataEntity>> getSalesData(
      String period, Map<String, dynamic> dateRange);
}
