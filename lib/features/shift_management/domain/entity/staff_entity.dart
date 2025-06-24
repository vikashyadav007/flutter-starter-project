import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'staff_entity.freezed.dart';

@freezed
class StaffEntity with _$StaffEntity {
  const factory StaffEntity({
    String? id,
    String? name,
    String? staffNumericId,
  }) = _StaffEntity;
}
