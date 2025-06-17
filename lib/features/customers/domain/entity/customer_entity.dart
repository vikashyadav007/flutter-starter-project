import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'customer_entity.freezed.dart';

@freezed
class CustomerEntity with _$CustomerEntity {
  const factory CustomerEntity({
    required String id,
    required String name,
    required String phone,
    required String contact,
    required String email,
    required double balance,
  }) = _CustomerEntity;
}
