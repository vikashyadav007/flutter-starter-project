import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/record_indent/domain/repositories/record_indent_repository.dart';

class GetAllCustomersUsecase {
  final RecordIndentRepository _repository;

  GetAllCustomersUsecase(this._repository);

  Future<Either<Failure, List<CustomerEntity>>> execute(
      {required String fuelPumpId}) async {
    return await _repository.getAllCustomers(fuelPumpId: fuelPumpId);
  }
}
