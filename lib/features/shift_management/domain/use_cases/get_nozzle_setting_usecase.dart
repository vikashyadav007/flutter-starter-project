import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/nozzle_setting_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetNozzleSettingUsecase {
  final ShiftManagementRepository _repository;

  GetNozzleSettingUsecase(this._repository);

  Future<Either<Failure, List<NozzleSettingEntity>>> execute({
    required String pumpId,
    required String fuelPumpId,
  }) async {
    return await _repository.getNozzleSettings(
        pumpId: pumpId, fuelPumpId: fuelPumpId);
  }
}
