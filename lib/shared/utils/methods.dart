import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/providers/search_by_indent_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/submit_indent_provider.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';

void invalidateRecordIndentProviders({required WidgetRef ref}) {
  ref.invalidate(indentNumberProvider);
  ref.read(searchByIndentProvider.notifier).reset();
  ref.read(submitIndentProvider.notifier).reset();
  ref.invalidate(customerIndentProvider);
  ref.invalidate(selectedIndentBookletProvider);
  ref.invalidate(customerVehicleListProvider);
  ref.invalidate(selectedCustomerVehicleProvider);
  ref.invalidate(selectedCustomerProvider);
  ref.invalidate(selectedTabIndexProvider);
  ref.invalidate(amountProvider);
  ref.invalidate(quantityProvider);
}

void invalidateActiveShifts({required WidgetRef ref}) {
  ref.invalidate(selectedStaffProvider);
  ref.invalidate(selectedPumpProvider);
  ref.invalidate(startingCashAmountProvider);
  ref.invalidate(pumpNozzleReadingsProvider);
  ref.invalidate(consumablesCartProvider);
  ref.invalidate(shiftsProvider);
  ref.invalidate(readingsProvider);
}
