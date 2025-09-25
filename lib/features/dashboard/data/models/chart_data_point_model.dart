import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/chart_data_point_entity.dart';

part 'chart_data_point_model.freezed.dart';
part 'chart_data_point_model.g.dart';

@freezed
abstract class ChartDataPointModel with _$ChartDataPointModel {
  const ChartDataPointModel._();
  
  const factory ChartDataPointModel({
    required String name,
    required double total,
    Map<String, dynamic>? additionalData,
  }) = _ChartDataPointModel;

  factory ChartDataPointModel.fromJson(Map<String, dynamic> json) =>
      _$ChartDataPointModelFromJson(json);

  ChartDataPointEntity toEntity() {
    return ChartDataPointEntity(
      name: name,
      total: total,
      additionalData: additionalData ?? {},
    );
  }
}