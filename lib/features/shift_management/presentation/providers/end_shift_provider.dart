import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_reconciliation.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/pump_closing_readings.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/shift_entity.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/complete_shift_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_transaction_consumables_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/create_transaction_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/reconcilize_shift_consumables_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/update_reading_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/domain/use_cases/update_transaction_usecase.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/end_shift_success_popup.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';

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

  final totalConsumablesSold = ref.watch(totalConsumablesSoldProvider);

  final consumablesReconciliation =
      ref.watch(consumablesReconciliationProvider);

  final fuelPumpEntity = ref.watch(selectedFuelPumpProvider);

  final createTransactionUsecase =
      ref.watch(createTransactionUsecaseProviderShiftManagement);

  final createConsumablesTransactionsUsecase =
      ref.watch(createTransactionConsumablesUsecaseProvider);

  final updateTransactionUsecase = ref.watch(updateTransactionUsecaseProvider);

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
    totalConsumablesSold: totalConsumablesSold,
    fuelPumpEntity: fuelPumpEntity,
    createTransactionUsecase: createTransactionUsecase,
    createConsumablesTransactionsUsecase: createConsumablesTransactionsUsecase,
    updateTransactionUsecase: updateTransactionUsecase,
  );
});

class EndShiftNotifier extends StateNotifier<EndShiftState> {
  final CompleteShiftUsecase completeShiftUsecase;
  final ReconcilizeShiftConsumablesUsecase reconcilizeShiftConsumablesUsecase;
  final UpdateReadingUsecase updateReadingUsecase;
  final CreateTransactionUsecase createTransactionUsecase;
  final CreateTransactionConsumablesUsecase
      createConsumablesTransactionsUsecase;
  final UpdateTransactionUsecase updateTransactionUsecase;

  final ShiftEntity? shiftEntity;
  final List<PumpClosingReadings> pumpClosingReadings;

  final String cardSales;
  final String cashSales;
  final String upiSales;
  final String otherSales;
  final String indentSales;

  final String cashCount;

  final String otherExpenses;
  final double totalConsumablesSold;

  final FuelPumpEntity? fuelPumpEntity;

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
    required this.totalConsumablesSold,
    required this.fuelPumpEntity,
    required this.createTransactionUsecase,
    required this.createConsumablesTransactionsUsecase,
    required this.updateTransactionUsecase,
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
        'cash_remaining': cashDifference,
        'cash_sales': cashSales.isEmpty ? '0' : cashSales,
        'closing_reading':
            reading.closingReading.isEmpty ? '0' : reading.closingReading,
        'consumable_expenses': totalConsumablesSold.toString(),
        'expenses': otherExpenses.isEmpty ? '0' : otherExpenses,
        'upi_sales': upiSales.isEmpty ? '0' : upiSales,
        'others_sales': otherSales.isEmpty ? '0' : otherSales,
        'indent_sales': indentSales.isEmpty ? '0' : indentSales,
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
      (success) {
        CreateConsumablesTransaction();
      },
    );
  }

  String shiftConsumableTransactionId = "";

  Future<void> CreateConsumablesTransaction() async {
    shiftConsumableTransactionId = "SHIFT-CONSUMABLE-${shiftEntity?.id}";
    final body = {
      "id": shiftConsumableTransactionId,
      "date": DateTime.now().toString(),
      "fuel_type": "CONSUMABLES",
      "amount": 0,
      "quantity": 0,
      "payment_method": "cash",
      "source": "shift_closure",
      "approval_status": "approved",
      "fuel_pump_id": fuelPumpEntity?.id,
      "staff_id": shiftEntity?.staff?.id,
    };

    final result = await createTransactionUsecase.execute(body: body);
    result.fold((failure) => state = EndShiftState.error(failure.message),
        (success) {
      createTransactionConsumables();
    });
  }

  Future<void> createTransactionConsumables() async {
    List<Map<String, dynamic>> body = [];
    for (ConsumablesReconciliation consumable in consumablesReconciliation) {
      int quantitySold = (consumable.shiftConsumables.quantityAllocated ?? 0) -
          consumable.returns.length;
      double perUnitPrice =
          consumable.shiftConsumables.consumables?.pricePerUnit ?? 0;

      final consumableData = {
        "transaction_id": shiftConsumableTransactionId,
        "consumable_id": consumable.shiftConsumables.id,
        "quantity_sold": quantitySold,
        "unit_price": perUnitPrice,
        "total_amount": perUnitPrice * quantitySold,
        "fuel_pump_id": fuelPumpEntity?.id,
      };

      body.add(consumableData);
    }

    final result =
        await createConsumablesTransactionsUsecase.execute(body: body);
    result.fold((failure) => state = EndShiftState.error(failure.message),
        (success) {
      updateTransactionConsumables();
    });
  }

  Future<void> updateTransactionConsumables() async {
    int quantity = 0;
    for (ConsumablesReconciliation consumable in consumablesReconciliation) {
      quantity += (consumable.shiftConsumables.quantityAllocated ?? 0) -
          consumable.returns.length;
    }

    final body = {
      "amount": totalConsumablesSold.toString(),
      "consumables_amount": totalConsumablesSold.toString(),
      "quantity": quantity,
    };

    final result = await updateTransactionUsecase.execute(
      body: body,
      shiftConsumableId: shiftConsumableTransactionId,
    );
    result.fold((failure) => state = EndShiftState.error(failure.message),
        (success) {});
  }
}
