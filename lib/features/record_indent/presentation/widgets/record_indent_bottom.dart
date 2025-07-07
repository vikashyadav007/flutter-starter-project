import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/search_by_customer_provider.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/search_by_indent_provider.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/submit_indent_provider.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/create_indent_success_popup.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/search_by_indent.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';

class RecordIndentBottom extends ConsumerWidget {
  int source = 0; // 0 for search by customer, 1 for search by indent
  RecordIndentBottom({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      selectedIndentBooket == null ||
                      selectedFuelType == null ||
                      amount.isEmpty ||
                      quantity.isEmpty ||
                      isIndentNumberVerified == false
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
