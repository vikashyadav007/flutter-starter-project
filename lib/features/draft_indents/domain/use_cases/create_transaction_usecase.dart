import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/draft_indents/domain/repositories/draft_indents_repository.dart';

class CreateTransactionUsecase {
  final DraftIndentsRepository _repository;

  CreateTransactionUsecase(this._repository);

  Future<Either<Failure, void>> execute({required Map<String, dynamic> body}) {
    return _repository.createTransaction(body: body);
  }
}
