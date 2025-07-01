class PumpSettingEntity {
  String? id;
  String? pumpNumber;
  int? nozzleCount;
  List<String> fuelTypes = [];
  DateTime? createdAt;
  String? fuelPumpId;

  PumpSettingEntity({
    this.id,
    this.pumpNumber,
    this.nozzleCount,
    required this.fuelTypes,
    this.createdAt,
    this.fuelPumpId,
  });

  @override
  String toString() {
    return 'Pump $pumpNumber (${fuelTypes.join(',')})';
  }
}
