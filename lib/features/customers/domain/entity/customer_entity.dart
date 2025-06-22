import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_entity.freezed.dart';

@freezed
class CustomerEntity with _$CustomerEntity {
  const factory CustomerEntity({
    String? id,
    String? name,
    String? phone,
    String? contact,
    String? email,
    double? balance,
  }) = _CustomerEntity;
}
