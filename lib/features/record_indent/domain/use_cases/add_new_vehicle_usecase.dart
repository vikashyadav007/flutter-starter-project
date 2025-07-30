import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class AddNewVehicleUsecase {
  final RecordIndentRepository _repository;

  AddNewVehicleUsecase(this._repository);

  Future<Either<Failure, VehicleEntity>> execute(
      {required Map<String, dynamic> body}) async {
    return await _repository.addNewVehicle(
      body: body,
    );
  }
}
