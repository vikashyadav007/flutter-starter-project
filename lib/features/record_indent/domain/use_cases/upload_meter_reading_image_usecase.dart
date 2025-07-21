import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/repositories/record_indent_repository.dart';

class UploadMeterReadingImageUsecase {
  final RecordIndentRepository _repository;

  UploadMeterReadingImageUsecase(this._repository);

  Future<Either<Failure, String>> execute({required File file}) async {
    return await _repository.uploadMeterReadingImage(
      file: file,
    );
  }
}
