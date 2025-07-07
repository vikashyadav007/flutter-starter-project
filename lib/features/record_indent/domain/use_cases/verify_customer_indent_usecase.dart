import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class VerifyCustomerIndentUsecase {
  final RecordIndentRepository _repository;

  VerifyCustomerIndentUsecase(this._repository);

  Future<Either<Failure, List<IndentEntity>>> execute(
      {required String indentNumber, required String bookletId}) async {
    return await _repository.verifyCustomerIndentNumber(
      indentNumber: indentNumber,
      bookletId: bookletId,
    );
  }
}
