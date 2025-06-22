import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:starter_project/features/home/domain/use_cases/get_fuel_pump_usecase.dart';
import 'package:starter_project/features/home/presentation/providers/providers.dart';
import 'package:starter_project/shared/providers/selected_fuel_pump.dart';

part 'home_provider.freezed.dart';

@freezed
class HomeState with _$HomeState {
  const factory HomeState.initial() = _Initial;
  const factory HomeState.fetchingFuelPump() = _FetchingFuelPump;
  const factory HomeState.fetchedFuelPump(List<FuelPumpEntity> fuelPumps) =
      _FetchedFuelPump;

  const factory HomeState.error(Failure error) = _Error;
}

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final getFuelPumpUsecase = ref.watch(getFuelPumpUsecaseProvider);
  final selectedFuelPump = ref.watch(selectedFuelPumpProvider.notifier);

  return HomeNotifier(
    getFuelPumpUsecase: getFuelPumpUsecase,
    selectedFuelPumpNotifier: selectedFuelPump,
  );
});

class HomeNotifier extends StateNotifier<HomeState> {
  GetFuelPumpUsecase getFuelPumpUsecase;
  SelectedFuelPumpNotifier selectedFuelPumpNotifier;
  HomeNotifier(
      {required this.getFuelPumpUsecase,
      required this.selectedFuelPumpNotifier})
      : super(const HomeState.initial()) {
    fetchFuelPump();
  }

  Future<void> fetchFuelPump() async {
    fetchingFuelPump();
    final result = await getFuelPumpUsecase.execute();
    result.fold(
      (failure) => error(failure),
      (fuelPumps) => fetchedFuelPump(fuelPumps),
    );
  }

  void fetchingFuelPump() {
    state = const HomeState.fetchingFuelPump();
  }

  void fetchedFuelPump(List<FuelPumpEntity> fuelPumps) {
    if (fuelPumps.isNotEmpty) {
      selectedFuelPumpNotifier.selectFuelPump(fuelPumps.first);
    } else {
      selectedFuelPumpNotifier.clearSelection();
    }
    state = HomeState.fetchedFuelPump(fuelPumps);
  }

  void error(Failure error) {
    state = HomeState.error(error);
  }
}
