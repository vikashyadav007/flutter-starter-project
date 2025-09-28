import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_data_entity.freezed.dart';

@freezed
class DashboardDataEntity with _$DashboardDataEntity {
  const factory DashboardDataEntity({
    String? salesAmount,
    String? fuelVolume,
    Map<String, String>? fuelVolumeByType,
    String? indentSalesAmount,
    String? customerPayments,
    String? consumablesSales,
    int? activeShifts,
    int? pendingApprovals,
    int? transactionCount,
    String? period,
    String? dateRange,
  }) = _DashboardDataEntity;
}
