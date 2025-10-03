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
    @JsonKey(name: "cashSales") String? cashSales,
    @JsonKey(name: "cardSales") String? cardSales,
    @JsonKey(name: "upiSales") String? upiSales,
    @JsonKey(name: "otherSales") String? otherSales,
    @JsonKey(name: "totalExpenses") String? totalExpenses,
  }) = _DashboardDataModel;

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataModelFromJson(json);

  DashboardDataEntity toEntity() {
    return DashboardDataEntity(
      salesAmount: salesAmount ?? '0',
      fuelVolume: fuelVolume ?? '0',
      fuelVolumeByType: fuelVolumeByType,
      indentSalesAmount: indentSalesAmount ?? '0',
      customerPayments: customerPayments ?? '0',
      consumablesSales: consumablesSales ?? '0',
      activeShifts: activeShifts ?? 0,
      pendingApprovals: pendingApprovals ?? 0,
      transactionCount: transactionCount ?? 0,
      period: period ?? '',
      dateRange: dateRange ?? '',
      cashSales: cashSales ?? '0',
      cardSales: cardSales ?? '0',
      upiSales: upiSales ?? '0',
      otherSales: otherSales ?? '0',
      totalExpenses: totalExpenses ?? '0',
    );
  }
}
