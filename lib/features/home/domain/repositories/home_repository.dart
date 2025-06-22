import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<FuelPumpEntity>>> getFuelPump();
}
