import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/draft_indents/domain/repositories/draft_indents_repository.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_entity.dart';

class GetDraftIndentsUsecase {
  final DraftIndentsRepository _repository;

  GetDraftIndentsUsecase(this._repository);

  Future<Either<Failure, List<IndentEntity>>> execute() {
    return _repository.getDraftIndents();
  }
}
