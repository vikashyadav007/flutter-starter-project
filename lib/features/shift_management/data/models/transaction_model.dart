import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:starter_project/features/shift_management/domain/entity/transaction_entity.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionModel with _$TransactionModel {
  const TransactionModel._();
  const factory TransactionModel({
    @JsonKey(name: "amount") double? amount,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  TransactionEntity toEntity() {
    return TransactionEntity(
      amount: amount,
    );
  }
}
