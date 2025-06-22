import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:starter_project/features/home/domain/repositories/home_repository.dart';

class GetFuelPumpUsecase {
  HomeRepository _homeRepository;
  GetFuelPumpUsecase({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;
  Future<Either<Failure, List<FuelPumpEntity>>> execute() async {
    return await _homeRepository.getFuelPump();
  }
}
