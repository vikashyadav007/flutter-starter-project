import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/draft_indents/domain/repositories/draft_indents_repository.dart';

class CompleteDraftIndentUsecase {
  final DraftIndentsRepository _repository;

  CompleteDraftIndentUsecase(this._repository);

  Future<Either<Failure, void>> execute(
      {required Map<String, dynamic> body, required String id}) {
    return _repository.completeDraftIndent(body: body, id: id);
  }
}
