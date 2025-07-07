import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/error_handler.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/home/data/data_sources/home_data_source.dart';
import 'package:fuel_pro_360/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:fuel_pro_360/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl extends HomeRepository {
  final HomeDataSource _homeDataSource;

  HomeRepositoryImpl({required homeDataSource})
      : _homeDataSource = homeDataSource;

  @override
  Future<Either<Failure, List<FuelPumpEntity>>> getFuelPump() async {
    try {
      final fuelData = await _homeDataSource.getFuelPump();
      return Right(fuelData.map<FuelPumpEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
