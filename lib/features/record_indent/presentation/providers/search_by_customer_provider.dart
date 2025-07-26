import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/verify_customer_indent_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/search_by_indent_provider.dart';
import 'package:fuel_pro_360/shared/utils/utils.dart';

final searchByCustomerProvider = StateNotifierProvider<SearchByCustomerNotifier,
    SearchByIndentProviderState>((ref) {
  final indentNumber = ref.watch(indentNumberProvider);

  final indentBookletEntity = ref.watch(selectedIndentBookletProvider);

  final indentNumberVerified = ref.watch(indentNumberVerifiedProvider.notifier);

  final verifyCustomerIndentUsecase =
      ref.watch(verifyCustomerIndentUsecaseProvider);

  return SearchByCustomerNotifier(
    indentNumber: indentNumber,
    indentBookletEntity: indentBookletEntity,
    verifyCustomerIndentUsecase: verifyCustomerIndentUsecase,
    indentNumberVerified: indentNumberVerified,
  );
});

class SearchByCustomerNotifier
    extends StateNotifier<SearchByIndentProviderState> {
  final VerifyCustomerIndentUsecase verifyCustomerIndentUsecase;

  String indentNumber;
  IndentBookletEntity? indentBookletEntity;

  StateController<bool> indentNumberVerified;

  SearchByCustomerNotifier({
    required this.verifyCustomerIndentUsecase,
    required this.indentNumber,
    required this.indentBookletEntity,
    required this.indentNumberVerified,
  }) : super(const SearchByIndentProviderState.initial());

  Future<void> verifyRecordIndent() async {
    state = const SearchByIndentProviderState.loading();

    if (isInRange(
        value: indentNumber,
        start: indentBookletEntity?.startNumber ?? "",
        end: indentBookletEntity?.endNumber ?? "")) {
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
            indentNumberVerified.state = true;
            state = SearchByIndentProviderState.verifiedRecordIndents(true);
          }
        },
      );
    } else {
      setError(
        Failure(
            code: 1,
            message: "This indent number not belongs to this booklet."),
      );
    }
  }

  void setError(Failure error) {
    state = SearchByIndentProviderState.error(error);
  }

  void reset() {
    state = const SearchByIndentProviderState.initial();
  }
}
