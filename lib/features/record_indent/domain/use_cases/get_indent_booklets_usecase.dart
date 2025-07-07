import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class GetIndentBookletsUsecase {
  final RecordIndentRepository _repository;

  GetIndentBookletsUsecase(this._repository);

  Future<Either<Failure, List<IndentBookletEntity>>> execute(
      {required String fuelPumpId}) async {
    return await _repository.getIndentBooklets(fuelPumpId: fuelPumpId);
  }
}
