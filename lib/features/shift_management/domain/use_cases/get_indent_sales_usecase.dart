import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class GetIndentSalesUsecase {
  final ShiftManagementRepository _repository;

  GetIndentSalesUsecase(this._repository);

  Future<Either<Failure, List<IndentEntity>>> execute({
    required String shiftId,
  }) async {
    return await _repository.getIndentSales(shiftId: shiftId);
  }
}
