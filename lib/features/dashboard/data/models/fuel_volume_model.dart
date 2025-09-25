import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/dashboard/domain/entities/fuel_volume_entity.dart';

part 'fuel_volume_model.freezed.dart';

@freezed
abstract class FuelVolumeModel with _$FuelVolumeModel {
  const FuelVolumeModel._();

  const factory FuelVolumeModel({
    required String name,
    required Map<String, double> fuelTypes,
  }) = _FuelVolumeModel;

  factory FuelVolumeModel.fromJson(Map<String, dynamic> json) {
    final Map<String, double> fuelTypes = {};

    // Extract fuel types from JSON (excluding 'name' field)
    json.forEach((key, value) {
      if (key != 'name' && value is num) {
        fuelTypes[key] = value.toDouble();
      }
    });

    return FuelVolumeModel(
      name: json['name'] as String,
      fuelTypes: fuelTypes,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {'name': name};
    json.addAll(fuelTypes.map((key, value) => MapEntry(key, value)));
    return json;
  }

  FuelVolumeEntity toEntity() {
    return FuelVolumeEntity(
      name: name,
      fuelTypes: fuelTypes,
    );
  }
}
