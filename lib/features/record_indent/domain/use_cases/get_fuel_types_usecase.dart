import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class GetFuelTypesUsecase {
  final RecordIndentRepository _repository;

  GetFuelTypesUsecase(this._repository);

  Future<Either<Failure, List<FuelEntity>>> execute(
      {required String fuelPumpId}) async {
    return await _repository.getFuelTypes(fuelPumpId: fuelPumpId);
  }
}
