import 'package:freezed_annotation/freezed_annotation.dart';

part 'pump_nozzle_readings.freezed.dart';

@freezed
class PumpNozzleReadings with _$PumpNozzleReadings {
  const factory PumpNozzleReadings({
    required String fuelType,
    required String currentReading,
  }) = _PumpNozzleReadings;
}
