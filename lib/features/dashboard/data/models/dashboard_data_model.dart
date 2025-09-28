import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_data_entity.dart';

part 'dashboard_data_model.freezed.dart';
part 'dashboard_data_model.g.dart';

@freezed
abstract class DashboardDataModel with _$DashboardDataModel {
  const DashboardDataModel._();
  const factory DashboardDataModel({
    @JsonKey(name: "salesAmount") String? salesAmount,
    @JsonKey(name: "fuelVolume") String? fuelVolume,
    @JsonKey(name: "fuelVolumeByType") Map<String, String>? fuelVolumeByType,
    @JsonKey(name: "indentSalesAmount") String? indentSalesAmount,
    @JsonKey(name: "customerPayments") String? customerPayments,
    @JsonKey(name: "consumablesSales") String? consumablesSales,
    @JsonKey(name: "activeShifts") int? activeShifts,
    @JsonKey(name: "pendingApprovals") int? pendingApprovals,
    @JsonKey(name: "transactionCount") int? transactionCount,
    @JsonKey(name: "period") String? period,
    @JsonKey(name: "dateRange") String? dateRange,
  }) = _DashboardDataModel;

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataModelFromJson(json);

  DashboardDataEntity toEntity() {
    return DashboardDataEntity(
      salesAmount: salesAmount,
      fuelVolume: fuelVolume,
      fuelVolumeByType: fuelVolumeByType,
      indentSalesAmount: indentSalesAmount,
      customerPayments: customerPayments,
      consumablesSales: consumablesSales,
      activeShifts: activeShifts,
      pendingApprovals: pendingApprovals,
      transactionCount: transactionCount,
      period: period,
      dateRange: dateRange,
    );
  }
}
