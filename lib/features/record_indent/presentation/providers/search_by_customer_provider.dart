import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/core/api/failure.dart';
import 'package:starter_project/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:starter_project/features/record_indent/domain/use_cases/verify_customer_indent_usecase.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/providers/search_by_indent_provider.dart';

final searchByCustomerProvider = StateNotifierProvider<SearchByCustomerNotifier,
    SearchByIndentProviderState>((ref) {
  final indentNumber = ref.watch(indentNumberProvider);

  final indentBookletEntity = ref.watch(selectedIndentBookletProvider);

  final verifyCustomerIndentUsecase =
      ref.watch(verifyCustomerIndentUsecaseProvider);

  return SearchByCustomerNotifier(
    indentNumber: indentNumber,
    indentBookletEntity: indentBookletEntity,
    verifyCustomerIndentUsecase: verifyCustomerIndentUsecase,
  );
});

class SearchByCustomerNotifier
    extends StateNotifier<SearchByIndentProviderState> {
  final VerifyCustomerIndentUsecase verifyCustomerIndentUsecase;

  String indentNumber;
  IndentBookletEntity? indentBookletEntity;

  SearchByCustomerNotifier(
      {required this.verifyCustomerIndentUsecase,
      required this.indentNumber,
      required this.indentBookletEntity})
      : super(const SearchByIndentProviderState.initial());

  Future<void> verifyRecordIndent() async {
    state = const SearchByIndentProviderState.loading();

    if (!(int.parse(indentNumber) >=
            int.parse(indentBookletEntity?.startNumber ?? "0") &&
        int.parse(indentNumber) <=
            int.parse(indentBookletEntity?.endNumber ?? "0"))) {
      setError(Failure(
          code: 1, message: "This indent number not belongs to this booklet."));

      return;
    }
    final result = await verifyCustomerIndentUsecase.execute(
      indentNumber: indentNumber.toString(),
      bookletId: indentBookletEntity?.id ?? "",
    );
    print(result);
    result.fold(
      (failure) => setError(failure),
      (indentList) {
        if (indentList.isNotEmpty) {
          setError(Failure(
              code: 1, message: "This indent number has already been used."));
        } else {
          state = SearchByIndentProviderState.verifiedRecordIndents(true);
        }
      },
    );
  }

  void setError(Failure error) {
    state = SearchByIndentProviderState.error(error);
  }

  void reset() {
    state = const SearchByIndentProviderState.initial();
  }
}
