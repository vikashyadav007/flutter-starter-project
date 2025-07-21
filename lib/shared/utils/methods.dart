import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/draft_indents/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/home/presentation/providers/home_provider.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/search_by_indent_provider.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/submit_indent_provider.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/providers/selected_fuel_pump.dart';

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
  ref.invalidate(meterReadingImageProvider);
  ref.invalidate(indentNumberVerifiedProvider);
}

void invalidateActiveShifts({required WidgetRef ref}) {
  ref.invalidate(shiftsProvider);
  ref.invalidate(selectedStaffProvider);
  ref.invalidate(selectedPumpProvider);
  ref.invalidate(startingCashAmountProvider);
  ref.invalidate(pumpNozzleReadingsProvider);
  ref.invalidate(consumablesCartProvider);
  ref.invalidate(readingsProvider);
}

void invalidateDraftIndents({required WidgetRef ref}) {
  ref.invalidate(selectedDraftIndentProvider);
  ref.invalidate(selectedStaffProvider);
  ref.invalidate(actualAmountProvider);
  ref.invalidate(actualQuantityProvider);
  ref.invalidate(additionalNotesProvider);
}

void invalidateCustomerProviders({required WidgetRef ref}) {
  ref.invalidate(allCustomersProvider);
}

void invalidateAllProviders({required WidgetRef ref}) {
  invalidateRecordIndentProviders(ref: ref);
  invalidateActiveShifts(ref: ref);
  invalidateDraftIndents(ref: ref);
  invalidateCustomerProviders(ref: ref);
  ref.invalidate(homeProvider);
  ref.invalidate(selectedFuelPumpProvider);
}
