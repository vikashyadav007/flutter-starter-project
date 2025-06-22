import 'package:freezed_annotation/freezed_annotation.dart';

part 'indent_entity.freezed.dart';

@freezed
class IndentEntity with _$IndentEntity {
  const factory IndentEntity({
    String? id,
  }) = _IndentEntity;
}
