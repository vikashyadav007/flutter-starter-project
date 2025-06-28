import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/draft_indents/domain/repositories/draft_indents_repository.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';

class GetDraftIndentsUsecase {
  final DraftIndentsRepository _repository;

  GetDraftIndentsUsecase(this._repository);

  Future<Either<Failure, List<IndentEntity>>> execute() {
    return _repository.getDraftIndents();
  }
}
