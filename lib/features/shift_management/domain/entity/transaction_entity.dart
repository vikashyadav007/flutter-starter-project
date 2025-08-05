import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

part 'transaction_entity.freezed.dart';

@freezed
class TransactionEntity with _$TransactionEntity {
  const factory TransactionEntity({
    double? amount,
    String? paymentMethod,
  }) = _TransactionEntity;
}
