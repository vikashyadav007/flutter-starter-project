import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/fuel_volume_entity.dart';
import 'package:fuel_pro_360/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetFuelVolumeDataUseCase {
  final DashboardRepository _repository;

  GetFuelVolumeDataUseCase(this._repository);

  Future<Either<Failure, List<FuelVolumeEntity>>> execute(
    String startDate,
    String endDate,
  ) async {
    return await _repository.getFuelVolumeData(startDate, endDate);
  }
}