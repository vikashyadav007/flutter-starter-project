import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/data/data_sources/record_indent_data_source.dart';
import 'package:starter_project/features/record_indent/data/respositories/record_indent_repository_impl.dart';
import 'package:starter_project/features/record_indent/domain/repositories/record_indent_repository.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/create_indent_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_indent_booklet_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_customer_vehicle_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_fuel_types_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_indent_booklets_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/get_staffs_usecase.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/verify_customer_indent_usecase.dart';

final RecordsProvider = Provider<RecordIndentRepository>((ref) {
  final recordIndentDataSource = RecordIndentDataSource();
  return RecordIndentRepositoryImpl(
      recordIndentDataSource: recordIndentDataSource);
});

final getCustomerIndentUsecaseProvider =
    Provider<GetCustomerIndentUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetCustomerIndentUsecase(recordIndentRepository);
});

final getCustomerVehicleUsecaseProvider =
    Provider<GetCustomerVehicleUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetCustomerVehicleUsecase(recordIndentRepository);
});

final getFuelTypesUsecaseProvider = Provider<GetFuelTypesUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetFuelTypesUsecase(recordIndentRepository);
});

final searchCustomerUsecaseProvider =
    Provider<GetCustomerVehicleUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetCustomerVehicleUsecase(recordIndentRepository);
});

final verifyCustomerIndentUsecaseProvider =
    Provider<VerifyCustomerIndentUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return VerifyCustomerIndentUsecase(recordIndentRepository);
});

final getIndentBookletUsecaseProvider =
    Provider<GetIndentBookletsUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetIndentBookletsUsecase(recordIndentRepository);
});

final getCustomerUsecaseProvider = Provider<GetCustomerUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetCustomerUsecase(recordIndentRepository);
});

final getStaffsUsecaseProvider = Provider<GetStaffsUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return GetStaffsUsecase(recordIndentRepository);
});

final createIndentUsecaseProvider = Provider<CreateIndentUsecase>((ref) {
  final recordIndentRepository = ref.watch(RecordsProvider);
  return CreateIndentUsecase(recordIndentRepository);
});
