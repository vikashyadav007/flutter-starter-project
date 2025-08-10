import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class CreateConsumablesTransactionsUsecase {
  final RecordIndentRepository _repository;

  CreateConsumablesTransactionsUsecase(this._repository);

  Future<Either<Failure, void>> execute(
      {required List<Map<String, dynamic>> body}) async {
    return await _repository.createTransactionConsumables(
      body: body,
    );
  }
}
