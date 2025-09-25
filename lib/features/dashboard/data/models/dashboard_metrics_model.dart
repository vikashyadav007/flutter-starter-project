import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/dashboard_metrics_entity.dart';

part 'dashboard_metrics_model.freezed.dart';
part 'dashboard_metrics_model.g.dart';

@freezed
abstract class DashboardMetricsModel with _$DashboardMetricsModel {
  const DashboardMetricsModel._();
  
  const factory DashboardMetricsModel({
    @JsonKey(name: 'total_sales') required String totalSales,
    required String customers,
    @JsonKey(name: 'fuel_volume') required String fuelVolume,
    required String growth,
  }) = _DashboardMetricsModel;

  factory DashboardMetricsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardMetricsModelFromJson(json);

  DashboardMetricsEntity toEntity() {
    return DashboardMetricsEntity(
      totalSales: totalSales,
      customers: customers,
      fuelVolume: fuelVolume,
      growth: growth,
    );
  }
}