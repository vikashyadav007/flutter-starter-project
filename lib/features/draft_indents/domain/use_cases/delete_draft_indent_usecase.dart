import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/draft_indents/domain/repositories/draft_indents_repository.dart';

class DeleteDraftIndentUsecase {
  final DraftIndentsRepository _repository;

  DeleteDraftIndentUsecase(this._repository);

  Future<Either<Failure, void>> execute({required String id}) {
    return _repository.deleteDraftIndent(id: id);
  }
}
