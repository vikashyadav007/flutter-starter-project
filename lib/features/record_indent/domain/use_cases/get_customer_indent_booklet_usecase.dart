import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:starter_project/features/record_indent/domain/repositories/record_indent_repository.dart';

class GetCustomerIndentUsecase {
  final RecordIndentRepository _repository;

  GetCustomerIndentUsecase(this._repository);

  Future<Either<Failure, List<IndentBookletEntity>>> execute(
      {String? customerId, String? fuelPumpId, String? id}) async {
    return await _repository.getCustomerIndentBooklets(
        customerId: customerId, fuelPumpId: fuelPumpId, id: id);
  }
}
