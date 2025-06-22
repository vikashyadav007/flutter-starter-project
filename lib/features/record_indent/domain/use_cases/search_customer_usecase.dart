import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/record_indent/domain/repositories/record_indent_repository.dart';

class SearchCustomerUsecase {
  final RecordIndentRepository _repository;

  SearchCustomerUsecase(this._repository);

  Future<Either<Failure, List<CustomerEntity>>> call(
      {required String searchKey}) async {
    return await _repository.searchCustomer(searchKey: searchKey);
  }
}
