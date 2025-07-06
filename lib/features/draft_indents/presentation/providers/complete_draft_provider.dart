import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:starter_project/features/draft_indents/domain/use_cases/complete_draft_indent_usecase.dart';
import 'package:starter_project/features/draft_indents/domain/use_cases/create_transaction_usecase.dart';
import 'package:starter_project/features/draft_indents/presentation/providers/provider.dart';
import 'package:starter_project/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/providers/selected_fuel_pump.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'complete_draft_provider.freezed.dart';

@freezed
class CompleteDraftState with _$CompleteDraftState {
  const factory CompleteDraftState.initial() = _Initial;
  const factory CompleteDraftState.submitting() = _Submitting;
  const factory CompleteDraftState.submitted(bool success) = _Submitted;
  const factory CompleteDraftState.error(String message) = _Error;
}

final completeDraftProvider =
    StateNotifierProvider<CompleteDraftNotifier, CompleteDraftState>((ref) {
  final completeDraftUsecase = ref.read(completeDraftIndentUsecaseProvider);
  final createTransactionUsecase = ref.read(createTransactionUsecaseProvider);
  final selectedDraftIndent = ref.watch(selectedDraftIndentProvider);
  final selectedFuelPump = ref.watch(selectedFuelPumpProvider);

  final actualQuantity = ref.watch(actualQuantityProvider);
  final actualAmount = ref.watch(actualAmountProvider);
  final selectedPaymentMethod = ref.watch(selectedPaymentMethodProvider);
  final additionalNotes = ref.watch(additionalNotesProvider);

  final selectedStaff = ref.watch(selectedStaffProvider);

  return CompleteDraftNotifier(
    completeDraftUsecase: completeDraftUsecase,
    createTransactionUsecase: createTransactionUsecase,
    actualAmount: actualAmount,
    actualQuantity: actualQuantity,
    selectedDraftIndent: selectedDraftIndent,
    selectedFuelPump: selectedFuelPump,
    selectedStaff: selectedStaff,
    selectedPaymentMethod: selectedPaymentMethod,
    additionalNotes: additionalNotes,
  );
});

class CompleteDraftNotifier extends StateNotifier<CompleteDraftState> {
  final CompleteDraftIndentUsecase completeDraftUsecase;
  final CreateTransactionUsecase createTransactionUsecase;

  StaffEntity? selectedStaff;

  final IndentEntity? selectedDraftIndent;
  final FuelPumpEntity? selectedFuelPump;

  final String? actualQuantity;
  final String? actualAmount;
  final String? selectedPaymentMethod;
  final String? additionalNotes;

  CompleteDraftNotifier({
    required this.completeDraftUsecase,
    required this.createTransactionUsecase,
    required this.selectedDraftIndent,
    required this.selectedFuelPump,
    required this.actualQuantity,
    required this.actualAmount,
    required this.selectedPaymentMethod,
    required this.additionalNotes,
    required this.selectedStaff,
  }) : super(const CompleteDraftState.initial());

  Future<void> submitDraft() async {
    state = const CompleteDraftState.submitting();
    final result1 = completeDraftIndent();
    final result2 = createTransaction();
    await Future.wait([result1, result2]).then((_) {
      state = const CompleteDraftState.submitted(true);
    }).catchError((error) {
      state = CompleteDraftState.error(error.toString());
    });
  }

  Future<void> completeDraftIndent() async {
    var body = {
      "status": "Completed",
      "quantity": actualQuantity != null
          ? double.tryParse(actualQuantity!) ?? 0.0
          : 0.0,
      "amount":
          actualAmount != null ? double.tryParse(actualAmount!) ?? 0.0 : 0.0,
      "approval_status": "approved",
      "approved_by": Supabase.instance.client.auth.currentUser?.id ?? "",
      "approval_date": DateTime.now().toIso8601String(),
      "approval_notes": additionalNotes ?? "",
      "created_by_staff_id": selectedStaff?.id ?? "",
    };

    final result = await completeDraftUsecase.execute(
      body: body,
      id: selectedDraftIndent?.id ?? "",
    );

    result.fold(
      (failure) => state = CompleteDraftState.error(failure.message),
      (success) => {},
    );
  }

  Future<void> createTransaction() async {
    var body = {
      "id": selectedDraftIndent?.id ?? "",
      "customer_id": selectedDraftIndent?.customerId ?? "",
      "vehicle_id": selectedDraftIndent?.vehicleId ?? "",
      "staff_id": selectedStaff?.id ?? "",
      "date": DateTime.now().toIso8601String(),
      "fuel_type": selectedDraftIndent?.fuelType ?? "",
      "amount":
          actualAmount != null ? double.tryParse(actualAmount!) ?? 0.0 : 0.0,
      "quantity": actualQuantity != null
          ? double.tryParse(actualQuantity!) ?? 0.0
          : 0.0,
      "payment_method": selectedPaymentMethod ?? "cash",
      "indent_id": selectedDraftIndent?.indentNumber ?? "",
      "source": "mobile",
      "fuel_pump_id": selectedFuelPump?.id ?? "",
      "approval_status": "approved"
    };

    final result = await createTransactionUsecase.execute(body: body);
    result.fold(
      (failure) => state = CompleteDraftState.error(failure.message),
      (success) {},
    );
  }
}
