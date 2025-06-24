import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/error_handler.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/record_indent/data/data_sources/record_indent_data_source.dart';
import 'package:starter_project/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/vehicle_entity.dart';
import 'package:starter_project/features/record_indent/domain/repositories/record_indent_repository.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';

class RecordIndentRepositoryImpl extends RecordIndentRepository {
  final RecordIndentDataSource _recordIndentDataSource;

  RecordIndentRepositoryImpl(
      {required RecordIndentDataSource recordIndentDataSource})
      : _recordIndentDataSource = recordIndentDataSource;

  @override
  Future<Either<Failure, List<IndentBookletEntity>>> getCustomerIndentBooklets(
      {String? customerId, String? fuelPumpId, String? id}) async {
    try {
      final fuelData = await _recordIndentDataSource.getCustomerIndentBooklets(
        customerId: customerId,
        fuelPumpId: fuelPumpId,
        id: id,
      );
      return Right(
          fuelData.map<IndentBookletEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<VehicleEntity>>> getCustomerVehicles(
      {required String customerId, required String fuelPumpId}) async {
    try {
      final customerVehicles = await _recordIndentDataSource
          .getCustomerVehicles(customerId: customerId, fuelPumpId: fuelPumpId);
      return Right(
          customerVehicles.map<VehicleEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<FuelEntity>>> getFuelTypes(
      {required String fuelPumpId}) async {
    try {
      final fuelTypes =
          await _recordIndentDataSource.getFuelTypes(fuelPumpId: fuelPumpId);
      return Right(fuelTypes.map<FuelEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<CustomerEntity>>> searchCustomer(
      {required String searchKey}) async {
    try {
      final customers =
          await _recordIndentDataSource.searchCustomer(searchKey: searchKey);
      return Right(customers.map<CustomerEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<IndentEntity>>> verifyCustomerIndentNumber(
      {required String indentNumber, required String bookletId}) async {
    try {
      final indents = await _recordIndentDataSource.verifyCustomerIndentNumber(
        indentNumber: indentNumber,
        bookletId: bookletId,
      );
      return Right(indents.map<IndentEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<IndentBookletEntity>>> getIndentBooklets(
      {required String fuelPumpId}) async {
    try {
      final indentBooklets = await _recordIndentDataSource.getIndentBooklets(
          fuelPumpId: fuelPumpId);
      return Right(indentBooklets
          .map<IndentBookletEntity>((e) => e.toEntity())
          .toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<CustomerEntity>>> getCustomer(
      {required String customerId, required String fuelPumpId}) async {
    try {
      final indentBooklets = await _recordIndentDataSource.getCustomer(
          customerId: customerId, fuelPumpId: fuelPumpId);
      return Right(
          indentBooklets.map<CustomerEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, List<StaffEntity>>> getStaffs(
      {required String fuelPumpId}) async {
    try {
      final indentBooklets =
          await _recordIndentDataSource.getStaffs(fuelPumpId: fuelPumpId);
      return Right(
          indentBooklets.map<StaffEntity>((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }

  @override
  Future<Either<Failure, void>> createIndent(
      {required Map<String, dynamic> body}) async {
    try {
      return Right(await _recordIndentDataSource.createIndent(body: body));
    } catch (e) {
      return Left(ErrorHandler.handle(e).failure);
    }
  }
}
