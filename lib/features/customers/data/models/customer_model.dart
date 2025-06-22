// To parse this JSON data, do
//
//     final customerModel = customerModelFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';

part 'customer_model.freezed.dart';
part 'customer_model.g.dart';

@freezed
abstract class CustomerModel with _$CustomerModel {
  const CustomerModel._();
  const factory CustomerModel({
    @JsonKey(name: "id") String? id,
    @JsonKey(name: "name") String? name,
    @JsonKey(name: "phone") String? phone,
    @JsonKey(name: "contact") String? contact,
    @JsonKey(name: "email") String? email,
    @JsonKey(name: "balance") double? balance,
  }) = _CustomerModel;

  factory CustomerModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerModelFromJson(json);

  toEntity() {
    return CustomerEntity(
      id: id,
      name: name,
      phone: phone,
      contact: contact,
      email: email,
      balance: balance,
    );
  }
}
