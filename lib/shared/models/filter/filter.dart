// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'filter.freezed.dart';

@freezed
class Filter with _$Filter {
  factory Filter({
    required String field,
    required String condition,
    required String value,
  }) = _Filter;
}
