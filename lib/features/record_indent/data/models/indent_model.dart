import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';

part 'indent_model.freezed.dart';
part 'indent_model.g.dart';

@freezed
abstract class IndentModel with _$IndentModel {
  const IndentModel._();
  const factory IndentModel({
    @JsonKey(name: "id") String? id,
  }) = _IndentModel;

  factory IndentModel.fromJson(Map<String, dynamic> json) =>
      _$IndentModelFromJson(json);

  toEntity() {
    return IndentEntity(
      id: id,
    );
  }
}
