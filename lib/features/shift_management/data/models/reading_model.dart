// To parse this JSON data, do
//
//     final readingModel = readingModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:fuel_pro_360/features/shift_management/domain/entity/reading_entity.dart';

part 'reading_model.freezed.dart';
part 'reading_model.g.dart';

@freezed
abstract class ReadingModel with _$ReadingModel {
  const ReadingModel._();
  const factory ReadingModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "pump_id") String? pumpId,
    @JsonKey(name: "shift_id") String? shiftId,
    @JsonKey(name: "opening_reading") double? openingReading,
    @JsonKey(name: "closing_reading") double? closingReading,
    @JsonKey(name: "staff_id") String? staffId,
    @JsonKey(name: "date") DateTime? date,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "cash_given") int? cashGiven,
    @JsonKey(name: "cash_remaining") dynamic cashRemaining,
    @JsonKey(name: "card_sales") dynamic cardSales,
    @JsonKey(name: "upi_sales") dynamic upiSales,
    @JsonKey(name: "cash_sales") dynamic cashSales,
    @JsonKey(name: "expenses") int? expenses,
    @JsonKey(name: "testing_fuel") double? testingFuel,
    @JsonKey(name: "consumable_expenses") double? consumableExpenses,
    @JsonKey(name: "fuel_pump_id") String? fuelPumpId,
    @JsonKey(name: "fuel_type") String? fuelType,
    @JsonKey(name: "indent_sales") double? indentSales,
    @JsonKey(name: "others_sales") double? othersSales,
    @JsonKey(name: "nozzle_number") int? nozzleNumber,
  }) = _ReadingModel;

  factory ReadingModel.fromJson(Map<String, dynamic> json) =>
      _$ReadingModelFromJson(json);

  ReadingEntity toEntity() {
    return ReadingEntity(
      id: id,
      pumpId: pumpId,
      shiftId: shiftId,
      openingReading: openingReading,
      closingReading: closingReading,
      staffId: staffId,
      date: date,
      createdAt: createdAt,
      cashGiven: cashGiven,
      cashRemaining: cashRemaining,
      cardSales: cardSales,
      upiSales: upiSales,
      cashSales: cashSales,
      expenses: expenses,
      testingFuel: testingFuel,
      consumableExpenses: consumableExpenses,
      fuelPumpId: fuelPumpId,
      fuelType: fuelType,
      indentSales: indentSales,
      othersSales: othersSales,
      nozzleNumber: nozzleNumber,
    );
  }
}
