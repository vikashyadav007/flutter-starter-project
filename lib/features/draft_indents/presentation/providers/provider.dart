import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/draft_indents/data/data_sources/draft_indents_datasource.dart';
import 'package:starter_project/features/draft_indents/data/respositories/draft_indent_repository_impl.dart';
import 'package:starter_project/features/draft_indents/domain/repositories/draft_indents_repository.dart';
import 'package:starter_project/features/draft_indents/domain/use_cases/complete_draft_indent_usecase.dart';
import 'package:starter_project/features/draft_indents/domain/use_cases/create_transaction_usecase.dart';
import 'package:starter_project/features/draft_indents/domain/use_cases/get_draft_indents_usecase.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_entity.dart';
import 'package:starter_project/features/shift_management/domain/entity/staff_entity.dart';

final draftIndentsRepositoryProvider = Provider<DraftIndentsRepository>((ref) {
  final draftIndentsDataSource = DraftIndentsDataSource();
  return DraftIndentRepositoryImpl(
    draftIndentsDataSource: draftIndentsDataSource,
  );
});

final getDraftIndentsUsecaseProvider = Provider<GetDraftIndentsUsecase>((ref) {
  final draftIndentsRepository = ref.watch(draftIndentsRepositoryProvider);
  return GetDraftIndentsUsecase(draftIndentsRepository);
});

final draftIndentsProvider = FutureProvider<List<IndentEntity>>((ref) async {
  final getDraftIndentsUsecase = ref.watch(getDraftIndentsUsecaseProvider);
  final result = await getDraftIndentsUsecase.execute();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (indents) => indents,
  );
});

final selectedDraftIndentProvider = StateProvider<IndentEntity?>((ref) => null);
final actualQuantityProvider = StateProvider<String>((ref) => '');
final actualAmountProvider = StateProvider<String>((ref) => '');

final selectedPaymentMethodProvider = StateProvider<String?>((ref) {
  return 'Cash';
});

final additionalNotesProvider = StateProvider<String>((ref) => '');

final completeDraftIndentUsecaseProvider =
    Provider<CompleteDraftIndentUsecase>((ref) {
  final draftIndentsRepository = ref.watch(draftIndentsRepositoryProvider);
  return CompleteDraftIndentUsecase(draftIndentsRepository);
});

final createTransactionUsecaseProvider =
    Provider<CreateTransactionUsecase>((ref) {
  final draftIndentsRepository = ref.watch(draftIndentsRepositoryProvider);
  return CreateTransactionUsecase(draftIndentsRepository);
});
