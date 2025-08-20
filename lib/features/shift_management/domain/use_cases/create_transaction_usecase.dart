import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class CreateTransactionUsecase {
  final ShiftManagementRepository _repository;

  CreateTransactionUsecase(this._repository);

  Future<Either<Failure, void>> execute(
      {required Map<String, dynamic> body}) async {
    return await _repository.createTransaction(
      body: body,
    );
  }
}
