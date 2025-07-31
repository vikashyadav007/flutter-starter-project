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

  @override
  // TODO: implement hashCode
  int get hashCode =>
      id?.hashCode ??
      0 ^
          number.hashCode ^
          type.hashCode ^
          createdAt.hashCode ^
          fuelPumpId.hashCode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! VehicleEntity) return false;
    return id == other.id &&
        number == other.number &&
        type == other.type &&
        createdAt == other.createdAt &&
        fuelPumpId == other.fuelPumpId;
  }
}
