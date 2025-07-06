import 'dart:convert';

class ConsumablesEntity {
  String? id;
  String? name;
  int? quantity;
  double? pricePerUnit;
  int? totalPrice;
  DateTime? date;
  DateTime? createdAt;
  String? category;
  String? unit;
  String? fuelPumpId;

  ConsumablesEntity({
    this.id,
    this.name,
    this.quantity,
    this.pricePerUnit,
    this.totalPrice,
    this.date,
    this.createdAt,
    this.category,
    this.unit,
    this.fuelPumpId,
  });

  @override
  String toString() {
    return '$name ($quantity $unit available)';
  }
}
