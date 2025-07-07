import 'package:fuel_pro_360/core/api/api_provider.dart';
import 'package:fuel_pro_360/features/home/data/data_sources/home_data_source.dart';
import 'package:fuel_pro_360/features/home/data/repositories/home_repository_impl.dart';
import 'package:fuel_pro_360/features/home/domain/repositories/home_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/home/domain/use_cases/get_fuel_pump_usecase.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final homeDataSource = HomeDataSource(apiClient);
  return HomeRepositoryImpl(homeDataSource: homeDataSource);
});

final getFuelPumpUsecaseProvider = Provider<GetFuelPumpUsecase>((ref) {
  final homeRepository = ref.watch(homeRepositoryProvider);
  return GetFuelPumpUsecase(homeRepository: homeRepository);
});
