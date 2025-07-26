import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fuel_pro_360/core/api/failure.dart';
import 'package:fuel_pro_360/features/customers/domain/entity/customer_entity.dart';
import 'package:fuel_pro_360/features/home/domain/entity/fuel_pump_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/entity/indent_booklet_entity.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_customer_indent_booklet_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_customer_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/get_indent_booklets_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/domain/use_cases/verify_customer_indent_usecase.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';
import 'package:fuel_pro_360/shared/utils/utils.dart';

part 'search_by_indent_provider.freezed.dart';

@freezed
class SearchByIndentProviderState with _$SearchByIndentProviderState {
  const factory SearchByIndentProviderState.initial() = _Initial;
  const factory SearchByIndentProviderState.loading() =
      _LoadingRecordIndentState;
  const factory SearchByIndentProviderState.verifiedRecordIndents(
      bool verified) = _VerifiedRecordIndents;
  const factory SearchByIndentProviderState.error(Failure error) = _Error;
}

final searchByIndentProvider =
    StateNotifierProvider<SearchByIndentNotifier, SearchByIndentProviderState>(
        (ref) {
  final getIndentBookletsUsecase = ref.watch(getIndentBookletUsecaseProvider);
  final verifyCustomerIndentUsecase =
      ref.watch(verifyCustomerIndentUsecaseProvider);
  final selectedPump = ref.watch(selectedFuelPumpProvider);

  final getCustomerIndentUsecase = ref.watch(getCustomerIndentUsecaseProvider);

  final getCustomerUsecase = ref.watch(getCustomerUsecaseProvider);

  final indentNumber = ref.watch(indentNumberProvider);

  final selectedCustomerNotifier = ref.watch(selectedCustomerProvider.notifier);

  final indentNumberVerified = ref.watch(indentNumberVerifiedProvider.notifier);

  return SearchByIndentNotifier(
    verifyCustomerIndentUsecase: verifyCustomerIndentUsecase,
    getIndentBookletsUsecase: getIndentBookletsUsecase,
    selectedFuelPump: selectedPump,
    getCustomerIndentUsecase: getCustomerIndentUsecase,
    getCustomerUsecase: getCustomerUsecase,
    indentNumber: indentNumber,
    selectedCustomerNotifier: selectedCustomerNotifier,
    indentNumberVerified: indentNumberVerified,
  );
});

class SearchByIndentNotifier
    extends StateNotifier<SearchByIndentProviderState> {
  final VerifyCustomerIndentUsecase verifyCustomerIndentUsecase;
  final GetIndentBookletsUsecase getIndentBookletsUsecase;
  final FuelPumpEntity? selectedFuelPump;
  final GetCustomerIndentUsecase getCustomerIndentUsecase;
  final GetCustomerUsecase getCustomerUsecase;
  StateController<CustomerEntity?> selectedCustomerNotifier;

  IndentBookletEntity? indentBookletEntity;

  String indentNumber;
  StateController<bool> indentNumberVerified;

  SearchByIndentNotifier({
    required this.verifyCustomerIndentUsecase,
    required this.getIndentBookletsUsecase,
    required this.selectedFuelPump,
    required this.getCustomerIndentUsecase,
    required this.getCustomerUsecase,
    required this.indentNumber,
    required this.selectedCustomerNotifier,
    required this.indentNumberVerified,
  }) : super(const SearchByIndentProviderState.initial());

  Future<List<IndentBookletEntity>> getAllIndentBooklets() async {
    if (selectedFuelPump == null) return [];
    final result = await getIndentBookletsUsecase.execute(
      fuelPumpId: selectedFuelPump!.id,
    );
    return result.fold(
      (failure) => [],
      (booklets) => booklets,
    );
  }

  Future<void> verifyRecordIndent() async {
    loading();

    List<IndentBookletEntity> booklets = await getAllIndentBooklets();

    bool flag = false;
    for (IndentBookletEntity booklet in booklets) {
      if (isInRange(
          value: indentNumber,
          start: booklet.startNumber ?? "0",
          end: booklet.endNumber ?? "0")) {
        indentBookletEntity = booklet;
        flag = true;
        break;
      }
    }
    print("from getAllIndentBooklets: $booklets");
    print("indentBookletEntity: $indentBookletEntity");

    if (flag == false) {
      setError(Failure(
        code: 1,
        message: "This indent number does not belong to any booklet.",
      ));
      return;
    }

    if (indentBookletEntity != null) {
      final result = await verifyCustomerIndentUsecase.execute(
        indentNumber: indentNumber.toString(),
        bookletId: indentBookletEntity?.id ?? "",
      );

      print("result from verifyCustomerIndentUsecase: $result");

      result.fold(
        (failure) => setError(failure),
        (indentList) {
          if (indentList.isNotEmpty) {
            setError(
              Failure(
                  code: 1,
                  message: "This indent number has already been used."),
            );
          } else {
            indentNumberVerified.state = true;
            state = SearchByIndentProviderState.verifiedRecordIndents(true);
            fetchCustomerDetails();
          }
        },
      );
    }
  }

  Future<void> fetchCustomerDetails() async {
    final result = await getCustomerUsecase.execute(
      customerId: indentBookletEntity?.customerId ?? "",
      fuelPumpId: selectedFuelPump?.id ?? "",
    );
    result.fold(
      (failure) => setError(failure),
      (customers) {
        if (customers.isNotEmpty) {
          selectedCustomerNotifier.state = customers.first;
        } else {
          selectedCustomerNotifier.state = null;
        }
      },
    );
  }

  void loading() {
    state = const SearchByIndentProviderState.loading();
  }

  void setError(Failure error) {
    state = SearchByIndentProviderState.error(error);
  }

  void reset() {
    state = const SearchByIndentProviderState.initial();
    indentBookletEntity = null;
    selectedCustomerNotifier.state = null;
  }
}
