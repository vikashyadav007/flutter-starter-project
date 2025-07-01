import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/error_handler.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/shift_management/data/data_sources/shift_management_data_source.dart';
import 'package:starter_project/features/shift_management/domain/entity/consumables_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/pump_setting_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/reading_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/shift_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';
import 'package:starter_project/features/shift_management/domain/repositories/shift_management_repository.dart';

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
}
