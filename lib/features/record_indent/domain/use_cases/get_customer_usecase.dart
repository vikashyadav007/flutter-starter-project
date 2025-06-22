import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/record_indent/domain/repositories/record_indent_repository.dart';

class GetCustomerUsecase {
  final RecordIndentRepository _repository;

  GetCustomerUsecase(this._repository);

  Future<Either<Failure, List<CustomerEntity>>> execute(
      {required String customerId, required String fuelPumpId}) async {
    return await _repository.getCustomer(
        customerId: customerId, fuelPumpId: fuelPumpId);
  }
}
