import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:fuel_pro_360/features/home/domain/repositories/home_repository.dart';

class GetFuelPumpUsecase {
  HomeRepository _homeRepository;
  GetFuelPumpUsecase({required HomeRepository homeRepository})
      : _homeRepository = homeRepository;
  Future<Either<Failure, List<FuelPumpEntity>>> execute() async {
    return await _homeRepository.getFuelPump();
  }
}
