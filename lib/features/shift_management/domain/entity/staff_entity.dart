class StaffEntity {
  String? id;
  String? name;
  String? phone;
  String? email;
  String? role;
  int? salary;
  DateTime? joiningDate;
  dynamic authId;
  bool? isActive;
  String? staffNumericId;
  String? fuelPumpId;
  bool? mobileOnlyAccess;

  StaffEntity({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.role,
    this.salary,
    this.joiningDate,
    this.authId,
    this.isActive,
    this.staffNumericId,
    this.fuelPumpId,
    this.mobileOnlyAccess,
  });

  @override
  int get hashCode => id?.hashCode ?? 0;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is StaffEntity && other.id == id;
  }

  @override
  String toString() {
    return '$name  ${staffNumericId == null ? '' : '($staffNumericId)'}';
  }
}
