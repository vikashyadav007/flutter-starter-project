import 'dart:convert';

class ActiveStaffEntity {
  String? staffId;
  String? staffName;
  String? shiftId;
  String? pumpDisplay;
  String? displayName;

  ActiveStaffEntity({
    this.staffId,
    this.staffName,
    this.shiftId,
    this.pumpDisplay,
    this.displayName,
  });

  @override
  String toString() {
    return staffName ?? displayName ?? "Unknown Staff";
  }
}
