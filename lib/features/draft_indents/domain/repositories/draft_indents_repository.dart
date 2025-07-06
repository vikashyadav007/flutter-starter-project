import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';

abstract class DraftIndentsRepository {
  Future<Either<Failure, List<IndentEntity>>> getDraftIndents();

  Future<Either<Failure, void>> completeDraftIndent(
      {required Map<String, dynamic> body, required String id});

  Future<Either<Failure, void>> createTransaction(
      {required Map<String, dynamic> body});

  Future<Either<Failure, void>> deleteDraftIndent({required String id});
}
