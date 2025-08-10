import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class UpdateConsumablesUsecase {
  final RecordIndentRepository _repository;

  UpdateConsumablesUsecase(this._repository);

  Future<Either<Failure, void>> execute(
      {required Map<String, dynamic> body,
      required String consumableId}) async {
    return await _repository.updateConsumables(
      body: body,
      consumableId: consumableId,
    );
  }
}
