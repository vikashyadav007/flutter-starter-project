import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/core/routing/app_router.dart';
import 'package:fuel_pro_360/features/draft_indents/domain/use_cases/delete_draft_indent_usecase.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/widgets/delete_draft_indent_success_popup%20.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_entity.dart';
import 'package:fuel_pro_360/shared/utils/methods.dart';

part 'delete_draft_indent_provider.freezed.dart';

@freezed
class DeleteIndentState with _$DeleteIndentState {
  const factory DeleteIndentState.initial() = _Initial;
  const factory DeleteIndentState.loading() = _Loading;
  const factory DeleteIndentState.success() = _Success;
  const factory DeleteIndentState.error(String message) = _Error;
}

final deleteDraftIndentProvider =
    StateNotifierProvider<DeleteDraftIndentNotifier, DeleteIndentState>((ref) {
  final deleteDraftIndentUsecase = ref.watch(deleteDraftIndentUsecaseProvider);
  final selectedDraftIndent = ref.watch(selectedDraftIndentProvider);
  return DeleteDraftIndentNotifier(
      deleteDraftIndentUsecase: deleteDraftIndentUsecase,
      selectedDraftIndent: selectedDraftIndent);
});

class DeleteDraftIndentNotifier extends StateNotifier<DeleteIndentState> {
  final DeleteDraftIndentUsecase deleteDraftIndentUsecase;

  final IndentEntity? selectedDraftIndent;

  DeleteDraftIndentNotifier({
    required this.deleteDraftIndentUsecase,
    required this.selectedDraftIndent,
  }) : super(const DeleteIndentState.initial());

  Future<void> deleteDraftIndent() async {
    state = const DeleteIndentState.loading();
    final result = await deleteDraftIndentUsecase.execute(
        id: selectedDraftIndent?.id ?? "");
    result.fold(
      (failure) => state = DeleteIndentState.error(failure.message),
      (_) {
        Navigator.of(navigatorKey!.currentState!.context).pop();

        DeleteDraftIndentSuccessPopup();
        state = const DeleteIndentState.success();
      },
    );
  }
}
