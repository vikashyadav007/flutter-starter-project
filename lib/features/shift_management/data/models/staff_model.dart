import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';

part 'staff_model.freezed.dart';
part 'staff_model.g.dart';

@freezed
abstract class StaffModel with _$StaffModel {
  const StaffModel._();
  const factory StaffModel({
    @JsonKey(name: "id") required String id,
    @JsonKey(name: "name") required String name,
    @JsonKey(name: "staff_numeric_id") required String staffNumericId,
  }) = _StaffModel;

  factory StaffModel.fromJson(Map<String, dynamic> json) =>
      _$StaffModelFromJson(json);

  toEntity() {
    return StaffEntity(
      id: id,
      name: name,
      staffNumericId: staffNumericId,
    );
  }
}
