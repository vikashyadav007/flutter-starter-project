import 'package:dartz/dartz.dart';
import 'package:fuel_pro_360/core/api/error_handler.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_entity.dart';
import 'package:fuel_pro_360/features/shift_management/data/data_sources/shift_management_data_source.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/nozzle_setting_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/reading_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_consumables_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/staff_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/transaction_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/repositories/shift_management_repository.dart';

class ShiftManagementRespositoryImpl extends ShiftManagementRepository {
  final ShiftManagementDataSource _shiftManagementDataSource;

  ShiftManagementRespositoryImpl(
      {required ShiftManagementDataSource shiftManagementDataSource})
      : _shiftManagementDataSource = shiftManagementDataSource;

  @override
  Future<Either<Failure, List<ShiftEntity>>> getShifts(
      {required String fuelPumpId}) async {
    try {
      final shifts = await _shiftManagementDataSource.getShifts(
        fuelPumpId: fuelPumpId,
      );
      return Right(shifts.map<ShiftEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ReadingEntity>>> getReadings(
      {required List<String> shiftIds}) async {
    try {
      final readings = await _shiftManagementDataSource.getReadings(
        shiftIds: shiftIds,
      );
      return Right(readings.map<ReadingEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ConsumablesEntity>>> getConsumables(
      {required String fuelPumpId}) async {
    try {
      final consumables = await _shiftManagementDataSource.getConsumables(
        fuelPumpId: fuelPumpId,
      );
      return Right(
          consumables.map<ConsumablesEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<PumpSettingEntity>>> getPumpSettings(
      {required String fuelPumpId}) async {
    try {
      final pumpSettings = await _shiftManagementDataSource.getFuelPumpSettings(
        fuelPumpId: fuelPumpId,
      );
      return Right(
          pumpSettings.map<PumpSettingEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<StaffEntity>>> getStaffs(
      {required String fuelPumpId}) async {
    try {
      final staffs = await _shiftManagementDataSource.getStaffs(
        fuelPumpId: fuelPumpId,
      );
      return Right(staffs.map<StaffEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ShiftEntity>>> createShift(
      {required Map<String, dynamic> body}) async {
    try {
      final readings = await _shiftManagementDataSource.createShift(body: body);

      return Right(readings.map<ShiftEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ReadingEntity>>> createReading(
      {required Map<String, dynamic> body}) async {
    try {
      final readings =
          await _shiftManagementDataSource.createReading(body: body);

      return Right(readings.map<ReadingEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> createShiftConsumables(
      {required Map<String, dynamic> body}) async {
    try {
      return Right(
          await _shiftManagementDataSource.createShiftConsumables(body: body));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ShiftConsumablesEntity>>> getShiftConsumables(
      {required String shiftId}) async {
    try {
      final staffs = await _shiftManagementDataSource.getShiftConsumables(
        shiftId: shiftId,
      );
      return Right(
          staffs.map<ShiftConsumablesEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ShiftConsumablesEntity>>>
      getAllocatedReturnedShiftConsumables({required String shiftId}) async {
    try {
      final staffs =
          await _shiftManagementDataSource.getAllocatedReturnedShiftConsumables(
        shiftId: shiftId,
      );
      return Right(
          staffs.map<ShiftConsumablesEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getTransactions(
      {required String shiftId}) async {
    try {
      final staffs = await _shiftManagementDataSource.getTransactions(
        shiftId: shiftId,
      );
      return Right(staffs.map<TransactionEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<IndentEntity>>> getIndentSales(
      {required String shiftId}) async {
    try {
      final staffs =
          await _shiftManagementDataSource.getIndentSales(shiftId: shiftId);
      return Right(staffs.map<IndentEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> completeShift(
      {required Map<String, dynamic> body, required String shiftId}) async {
    try {
      return Right(await _shiftManagementDataSource.completeShift(
        body: body,
        shiftId: shiftId,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> reconilizeShiftConsumables(
      {required Map<String, dynamic> body, required String id}) async {
    try {
      return Right(await _shiftManagementDataSource.reconilizeShiftConsumables(
        body: body,
        id: id,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateReading(
      {required Map<String, dynamic> body,
      required String shiftId,
      required String fuelType}) async {
    try {
      return Right(await _shiftManagementDataSource.updateReading(
        body: body,
        shiftId: shiftId,
        fuelType: fuelType,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> createTransaction(
      {required Map<String, dynamic> body}) async {
    try {
      return Right(await _shiftManagementDataSource.createTransaction(
        body: body,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
      {required Map<String, dynamic> body,
      required String shiftConsumableId}) async {
    try {
      return Right(await _shiftManagementDataSource.updateTransaction(
        body: body,
        shiftConsumableId: shiftConsumableId,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> createConsumablesTransaction(
      {required List<Map<String, dynamic>> body}) async {
    try {
      return Right(
          await _shiftManagementDataSource.createConsumablesTransaction(
        body: body,
      ));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<ReadingEntity>>> getPumpReadings(
      {required String pumpId, required String fuelPumpId}) async {
    try {
      final readings = await _shiftManagementDataSource.getPumpReadings(
        pumpId: pumpId,
        fuelPumpId: fuelPumpId,
      );
      return Right(readings.map<ReadingEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<NozzleSettingEntity>>> getNozzleSettings(
      {required String pumpId, required String fuelPumpId}) async {
    try {
      final readings = await _shiftManagementDataSource.getNozzleSetting(
        pumpId: pumpId,
        fuelPumpId: fuelPumpId,
      );
      return Right(
          readings.map<NozzleSettingEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
