import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_project/features/shift_management/domain/entity/consumables_reconciliation.dart';
import 'package:starter_project/features/shift_management/domain/entity/pump_closing_readings.dart';
import 'package:starter_project/features/shift_management/domain/entity/shift_entity.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/complete_shift_usecase.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/reconcilize_shift_consumables_usecase.dart';
import 'package:starter_project/features/shift_management/domain/use_cases/update_reading_usecase.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/features/shift_management/presentation/widgets/end_shift_success_popup.dart';

part 'end_shift_provider.freezed.dart';

@freezed
class EndShiftState with _$EndShiftState {
  const factory EndShiftState.initial() = _Initial;
  const factory EndShiftState.submitting() = _Submitting;
  const factory EndShiftState.submitted(bool success) = _Submitted;
  const factory EndShiftState.error(String message) = _Error;
}

final endShiftProvider =
    StateNotifierProvider<EndShiftNotifier, EndShiftState>((ref) {
  final completeShiftUsecase = ref.read(completeShiftUsecaseProvider);
  final reconcilizeShiftConsumablesUsecase =
      ref.read(reconcilizeShiftConsumablesUsecaseProvider);
  final updateReadingUsecase = ref.read(updateReadingUsecaseProvider);

  final shiftEntity = ref.watch(selectedShiftProvider);
  final pumpClosingReadings = ref.watch(pumpClosingReadingsProvider);

  final cardSales = ref.watch(cardSalesProvider);
  final cashSales = ref.watch(cashSalesProvider);
  final upiSales = ref.watch(upiSalesProvider);
  final otherSales = ref.watch(otherSalesProvider);
  final indentSales = ref.watch(indentSalesProvider);

  final otherExpenses = ref.watch(otherExpensesProvider);

  final cashCount = ref.watch(cashCountProvider);

  final consumablesReconciliation =
      ref.watch(consumablesReconciliationProvider);

  return EndShiftNotifier(
    completeShiftUsecase: completeShiftUsecase,
    reconcilizeShiftConsumablesUsecase: reconcilizeShiftConsumablesUsecase,
    updateReadingUsecase: updateReadingUsecase,
    shiftEntity: shiftEntity,
    pumpClosingReadings: pumpClosingReadings,
    cardSales: cardSales,
    cashSales: cashSales,
    upiSales: upiSales,
    otherSales: otherSales,
    indentSales: indentSales,
    otherExpenses: otherExpenses,
    cashCount: cashCount,
    consumablesReconciliation: consumablesReconciliation,
  );
});

class EndShiftNotifier extends StateNotifier<EndShiftState> {
  final CompleteShiftUsecase completeShiftUsecase;
  final ReconcilizeShiftConsumablesUsecase reconcilizeShiftConsumablesUsecase;
  final UpdateReadingUsecase updateReadingUsecase;

  final ShiftEntity? shiftEntity;
  final List<PumpClosingReadings> pumpClosingReadings;

  final String cardSales;
  final String cashSales;
  final String upiSales;
  final String otherSales;
  final String indentSales;

  final String cashCount;

  final String otherExpenses;

  final List<ConsumablesReconciliation> consumablesReconciliation;
  double cashDifference = 0;

  EndShiftNotifier({
    required this.completeShiftUsecase,
    required this.reconcilizeShiftConsumablesUsecase,
    required this.updateReadingUsecase,
    required this.shiftEntity,
    required this.pumpClosingReadings,
    required this.cardSales,
    required this.cashSales,
    required this.upiSales,
    required this.otherSales,
    required this.indentSales,
    required this.otherExpenses,
    required this.cashCount,
    required this.consumablesReconciliation,
  }) : super(const EndShiftState.initial());

  Future<void> endShift() async {
    state = const EndShiftState.submitting();

    double expectedCashCount = (shiftEntity?.readings?[0].cashGiven ?? 0.0) +
        (cashSales.isEmpty ? 0.0 : double.tryParse(cashSales) ?? 0.0) -
        (double.tryParse(otherExpenses ?? "0.0") ?? 0.0);

    cashDifference =
        (cashCount.isEmpty ? 0.0 : double.tryParse(cashCount) ?? 0.0) -
            expectedCashCount;

    final result1 = completeShift();
    final result2 = updateReadingHelper();
    final result3 = reconcileConsumablesHelper();

    await Future.wait([result1, result2, result3]);
    state = const EndShiftState.submitted(true);
    endShiftSuccessPopup();
  }

  Future<void> completeShift() async {
    final body = {
      'cash_remaining': cashDifference,
      'end_time': DateTime.now().toIso8601String(),
      'status': 'completed',

      // Add other necessary fields here
    };
    final result = await completeShiftUsecase.execute(
        body: body, shiftId: shiftEntity?.id ?? '');
    result.fold(
      (failure) => state = EndShiftState.error(failure.message),
      (success) {},
    );
  }

  Future<void> updateReadingHelper() async {
    for (var reading in pumpClosingReadings) {
      final body = {
        'card_sales': cardSales.isEmpty ? '0' : cardSales,
        'cash_sales': cashSales.isEmpty ? '0' : cashSales,
        'upi_sales': upiSales.isEmpty ? '0' : upiSales,
        'others_sales': otherSales.isEmpty ? '0' : otherSales,
        'indent_sales': indentSales.isEmpty ? '0' : indentSales,
        'cash_remaining': cashDifference,
        'closing_reading':
            reading.closingReading.isEmpty ? '0' : reading.closingReading,
        'expenses': otherExpenses.isEmpty ? '0' : otherExpenses,
        'testing_fuel': reading.testingFuelReading.isEmpty
            ? '0'
            : reading.testingFuelReading,
      };
      await updateReading(body, reading.reading.fuelType ?? '');
    }
  }

  Future<void> updateReading(body, String fuelType) async {
    state = const EndShiftState.submitting();
    final result = await updateReadingUsecase.execute(
        body: body, shiftId: shiftEntity?.id ?? '', fuelType: fuelType);
    result.fold(
      (failure) => state = EndShiftState.error(failure.message),
      (success) {},
    );
  }

  Future<void> reconcileConsumablesHelper() async {
    for (var consumable in consumablesReconciliation) {
      final body = {
        'quantity_returned': consumable.returns.isEmpty
            ? '0'
            : consumable.shiftConsumables.quantityAllocated,
        'status': 'returned',
      };
      await reconcileConsumables(
          body: body, id: consumable.shiftConsumables.id);
    }
  }

  Future<void> reconcileConsumables({required body, required id}) async {
    state = const EndShiftState.submitting();
    final result =
        await reconcilizeShiftConsumablesUsecase.execute(body: body, id: id);
    result.fold(
      (failure) => state = EndShiftState.error(failure.message),
      (success) {},
    );
  }
}
