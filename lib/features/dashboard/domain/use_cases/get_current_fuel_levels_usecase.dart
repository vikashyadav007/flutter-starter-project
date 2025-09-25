import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetCurrentFuelLevelsUseCase {
  final DashboardRepository _repository;

  GetCurrentFuelLevelsUseCase(this._repository);

  Future<Either<Failure, Map<String, double>>> execute() async {
    return await _repository.getCurrentFuelLevels();
  }
}