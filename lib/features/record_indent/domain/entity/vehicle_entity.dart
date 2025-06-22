class VehicleEntity {
  String? number;
  String? type;
  String? id;
  String? customerId;
  String? capacity;
  DateTime? createdAt;
  String? fuelPumpId;

  VehicleEntity({
    this.id,
    this.customerId,
    this.number,
    this.type,
    this.capacity,
    this.createdAt,
    this.fuelPumpId,
  });

  @override
  String toString() {
    return "$number ($type)";
  }
}
