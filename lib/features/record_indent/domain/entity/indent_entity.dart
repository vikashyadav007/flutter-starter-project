import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/customers/domain/entity/customer_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/vehicle_entity.dart';

part 'indent_entity.freezed.dart';

@freezed
class IndentEntity with _$IndentEntity {
  const factory IndentEntity({
    String? id,
    String? customerId,
    String? vehicleId,
    String? fuelType,
    double? quantity,
    double? amount,
    String? status,
    DateTime? createdAt,
    String? bookletId,
    String? indentNumber,
    DateTime? date,
    int? discountAmount,
    String? approvalStatus,
    String? source,
    dynamic approvedBy,
    dynamic approvalDate,
    dynamic approvalNotes,
    String? fuelPumpId,
    String? createdByStaffId,
    CustomerEntity? customers,
    VehicleEntity? vehicles,
  }) = _IndentEntity;
}
