import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetPumpSettingsUsecase {
  final ShiftManagementRepository _repository;

  GetPumpSettingsUsecase(this._repository);

  Future<Either<Failure, List<PumpSettingEntity>>> execute({
    required String fuelPumpId,
  }) async {
    return await _repository.getPumpSettings(fuelPumpId: fuelPumpId);
  }
}
