import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class CreateIndentUsecase {
  final RecordIndentRepository _repository;

  CreateIndentUsecase(this._repository);

  Future<Either<Failure, void>> execute(
      {required Map<String, dynamic> body}) async {
    return await _repository.createIndent(
      body: body,
    );
  }
}
