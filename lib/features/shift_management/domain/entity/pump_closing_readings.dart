import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_project/features/shift_management/domain/entity/reading_entity.dart';

part 'pump_closing_readings.freezed.dart';

@freezed
class PumpClosingReadings with _$PumpClosingReadings {
  const factory PumpClosingReadings({
    required ReadingEntity reading,
    required String closingReading,
    required String totalLiters,
    required String testingFuelReading,
  }) = _PumpClosingReadings;
}
