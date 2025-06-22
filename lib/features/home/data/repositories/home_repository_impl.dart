import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/error_handler.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/home/data/data_sources/home_data_source.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:starter_project/features/home/domain/repositories/home_repository.dart';

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
