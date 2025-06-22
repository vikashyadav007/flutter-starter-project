import 'package:dartz/dartz.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/customers/domain/entity/customer_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/fuel_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/vehicle_entity.dart';

abstract class RecordIndentRepository {
  Future<Either<Failure, List<VehicleEntity>>> getCustomerVehicles(
      {required String customerId, required String fuelPumpId});
  Future<Either<Failure, List<IndentBookletEntity>>> getCustomerIndentBooklets(
      {required String customerId, required String fuelPumpId});
  Future<Either<Failure, List<FuelEntity>>> getFuelTypes(
      {required String fuelPumpId});
  Future<Either<Failure, List<IndentEntity>>> verifyCustomerIndentNumber(
      {required String indentNumber, required String bookletId});
  Future<Either<Failure, List<CustomerEntity>>> searchCustomer(
      {required String searchKey});

  Future<Either<Failure, List<IndentBookletEntity>>> getIndentBooklets(
      {required String fuelPumpId});

  Future<Either<Failure, List<CustomerEntity>>> getCustomer(
      {required String customerId, required String fuelPumpId});
}
