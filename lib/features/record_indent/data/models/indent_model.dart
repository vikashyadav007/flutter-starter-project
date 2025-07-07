import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/customers/data/models/customer_model.dart';
import 'package:fuel_pro_360/features/record_indent/data/models/vehicle_model.dart';

import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_entity.dart';

part 'indent_model.freezed.dart';
part 'indent_model.g.dart';

@freezed
abstract class IndentModel with _$IndentModel {
  const IndentModel._();
  const factory IndentModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "customer_id") String? customerId,
    @JsonKey(name: "vehicle_id") String? vehicleId,
    @JsonKey(name: "fuel_type") String? fuelType,
    @JsonKey(name: "quantity") double? quantity,
    @JsonKey(name: "amount") double? amount,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "created_at") DateTime? createdAt,
    @JsonKey(name: "booklet_id") String? bookletId,
    @JsonKey(name: "indent_number") String? indentNumber,
    @JsonKey(name: "date") DateTime? date,
    @JsonKey(name: "discount_amount") int? discountAmount,
    @JsonKey(name: "approval_status") String? approvalStatus,
    @JsonKey(name: "source") String? source,
    @JsonKey(name: "approved_by") dynamic approvedBy,
    @JsonKey(name: "approval_date") dynamic approvalDate,
    @JsonKey(name: "approval_notes") dynamic approvalNotes,
    @JsonKey(name: "fuel_pump_id") String? fuelPumpId,
    @JsonKey(name: "created_by_staff_id") String? createdByStaffId,
    @JsonKey(name: "customers") CustomerModel? customers,
    @JsonKey(name: "vehicles") VehicleModel? vehicles,
  }) = _IndentModel;

  factory IndentModel.fromJson(Map<String, dynamic> json) =>
      _$IndentModelFromJson(json);

  IndentEntity toEntity() {
    return IndentEntity(
      id: id,
      customerId: customerId,
      vehicleId: vehicleId,
      fuelType: fuelType,
      quantity: quantity,
      amount: amount,
      status: status,
      createdAt: createdAt,
      bookletId: bookletId,
      indentNumber: indentNumber,
      date: date,
      discountAmount: discountAmount,
      approvalStatus: approvalStatus,
      source: source,
      approvedBy: approvedBy,
      approvalDate: approvalDate,
      approvalNotes: approvalNotes,
      fuelPumpId: fuelPumpId,
      createdByStaffId: createdByStaffId,
      customers: customers?.toEntity(),
      vehicles: vehicles?.toEntity(),
    );
  }
}
