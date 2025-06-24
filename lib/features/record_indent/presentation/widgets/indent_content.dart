import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/submit_indent_provider.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/amount_quantity_row.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/fuel_type_droopdown.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/indent_dropdown.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/search_by_indent.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/vehicle_dropdown.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';

class IndentContent extends ConsumerWidget {
  IndentContent({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(selectedCustomerProvider);
    final selectedTabIndex = ref.watch(selectedTabIndexProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        selectedCustomer == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text("Selected Customer: ${selectedCustomer.name}"),
              ),
        VehicleDropdown(),
        const SizedBox(height: 20),
        IndentBookletDropdown(),
        const SizedBox(height: 20),
        if (selectedTabIndex == 1) ...[
          SearchByIndent(),
          const SizedBox(height: 20),
        ],
        FuelTypeDropdown(),
        const SizedBox(height: 20),
        AmountQuantityRow(),
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
              onPressed: () async {
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
