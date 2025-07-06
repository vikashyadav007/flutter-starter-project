import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/error_handler.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/draft_indents/data/data_sources/draft_indents_datasource.dart';
import 'package:starter_project/features/draft_indents/domain/repositories/draft_indents_repository.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';

class DraftIndentRepositoryImpl extends DraftIndentsRepository {
  DraftIndentsDataSource _draftIndentsDataSource;
  DraftIndentRepositoryImpl({
    required DraftIndentsDataSource draftIndentsDataSource,
  }) : _draftIndentsDataSource = draftIndentsDataSource;

  @override
  Future<Either<Failure, List<IndentEntity>>> getDraftIndents() async {
    try {
      final shifts = await _draftIndentsDataSource.getIndents();
      return Right(shifts.map<IndentEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> completeDraftIndent(
      {required Map<String, dynamic> body, required String id}) async {
    try {
      return Right(await _draftIndentsDataSource.completeDraftIndent(
          body: body, id: id));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> createTransaction(
      {required Map<String, dynamic> body}) async {
    try {
      return Right(await _draftIndentsDataSource.createTransaction(body: body));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> deleteDraftIndent({required String id}) async {
    try {
      return Right(await _draftIndentsDataSource.deleteDraftIndent(id: id));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
