import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/home/domain/entity/fuel_pump_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<FuelPumpEntity>>> getFuelPump();
}
