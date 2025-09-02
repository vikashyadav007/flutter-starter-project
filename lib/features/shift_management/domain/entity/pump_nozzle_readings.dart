import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/nozzle_setting_entity.dart';

part 'pump_nozzle_readings.freezed.dart';

@freezed
class PumpNozzleReadings with _$PumpNozzleReadings {
  const factory PumpNozzleReadings({
    required NozzleSettingEntity nozzle,
    required String currentReading,
  }) = _PumpNozzleReadings;
}
