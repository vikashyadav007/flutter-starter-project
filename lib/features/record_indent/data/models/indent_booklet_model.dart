import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';

part 'indent_booklet_model.freezed.dart';
part 'indent_booklet_model.g.dart';

@freezed
abstract class IndentBookletModel with _$IndentBookletModel {
  const IndentBookletModel._();
  const factory IndentBookletModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "start_number") String? startNumber,
    @JsonKey(name: "end_number") String? endNumber,
    @JsonKey(name: "used_indents") int? usedIndents,
    @JsonKey(name: "total_indents") int? totalIndents,
    @JsonKey(name: "status") String? status,
    @JsonKey(name: "customer_id") String? customerId,
  }) = _IndentBookletModel;

  factory IndentBookletModel.fromJson(Map<String, dynamic> json) =>
      _$IndentBookletModelFromJson(json);

  toEntity() {
    return IndentBookletEntity(
      id: id,
      startNumber: startNumber,
      endNumber: endNumber,
      usedIndents: usedIndents,
      totalIndents: totalIndents,
      status: status,
      customerId: customerId,
    );
  }
}
