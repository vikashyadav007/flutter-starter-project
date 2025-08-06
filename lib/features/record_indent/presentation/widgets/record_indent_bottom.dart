import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/submit_indent_provider.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/active_staff_dropdown.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/bill_number_container.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/indent_date_container.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/meter_reading_image.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';
import 'package:fuel_pro_360/shared/widgets/consumables_listings.dart';

class RecordIndentBottom extends ConsumerWidget {
  int source = 0;
  RecordIndentBottom({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IndentDateContainer(),
        const SizedBox(height: 20),
        ActiveStaffDropdown(),
        const SizedBox(height: 20),
        BillNumberContainer(),
        const SizedBox(height: 20),
        ConsumablesListings(),
        const SizedBox(height: 20),
        MeterReadingImage(),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: UiColors.backgroundGrey,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            "Mobile indents require approval from the web system before being processed.",
          ),
        ),
        const SizedBox(height: 20),
        Consumer(builder: (context, ref, child) {
          final submitIndentState = ref.watch(submitIndentProvider);
          final selectedCustomer = ref.watch(selectedCustomerProvider);
          final selectedVehicle = ref.watch(selectedCustomerProvider);
          final selectedIndentBooket = ref.watch(selectedIndentBookletProvider);
          final selectedFuelType = ref.watch(selectedFuelProvider);
          final amount = ref.watch(amountProvider);
          final quantity = ref.watch(quantityProvider);
          bool isIndentNumberVerified = ref.watch(indentNumberVerifiedProvider);
          bool noIndentCheckbox = ref.watch(noIndentCheckboxProvider);
          final selectedStaff = ref.watch(selectedActiveStaffProvider);

          return SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: selectedCustomer == null ||
                      selectedVehicle == null ||
                      selectedFuelType == null ||
                      amount.isEmpty ||
                      quantity.isEmpty ||
                      selectedStaff == null ||
                      (!noIndentCheckbox &&
                          (selectedIndentBooket == null ||
                              isIndentNumberVerified == false))
                  ? null
                  : () async {
                      ref.read(submitIndentProvider.notifier).submitIndent();
                    },
              child: submitIndentState.maybeWhen(
                submitting: () => const SizedBox(
                  height: 30,
                  width: 30,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
                orElse: () => const Text(
                  "Submit for Approval",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}
