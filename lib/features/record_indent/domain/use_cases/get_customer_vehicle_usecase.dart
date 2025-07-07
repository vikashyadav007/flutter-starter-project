import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class GetCustomerVehicleUsecase {
  final RecordIndentRepository _repository;

  GetCustomerVehicleUsecase(this._repository);

  Future<Either<Failure, List<VehicleEntity>>> execute(
      {required String customerId, required String fuelPumpId}) async {
    return await _repository.getCustomerVehicles(
        customerId: customerId, fuelPumpId: fuelPumpId);
  }
}
