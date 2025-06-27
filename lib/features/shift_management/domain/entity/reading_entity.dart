import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'reading_entity.freezed.dart';

@freezed
class ReadingEntity with _$ReadingEntity {
  const factory ReadingEntity({
    String? id,
    String? pumpId,
    String? shiftId,
    int? openingReading,
    dynamic closingReading,
    String? staffId,
    DateTime? date,
    DateTime? createdAt,
    int? cashGiven,
    dynamic cashRemaining,
    dynamic cardSales,
    dynamic upiSales,
    dynamic cashSales,
    int? expenses,
    int? testingFuel,
    int? consumableExpenses,
    String? fuelPumpId,
    String? fuelType,
    int? indentSales,
    int? othersSales,
  }) = _ReadingEntity;
}
