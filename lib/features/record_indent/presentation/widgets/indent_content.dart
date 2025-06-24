import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_customer_provider.dart';
import 'package:starter_project/features/record_indent/presentation/providers/submit_indent_provider.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/amount_quantity_row.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/fuel_type_droopdown.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/indent_dropdown.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/vehicle_dropdown.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class IndentContent extends ConsumerWidget {
  TextEditingController amountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController indentNumberController = TextEditingController();
  final GlobalKey<FormFieldState> _dropdownKey = GlobalKey<FormFieldState>();

  IndentContent({super.key, required this.indentNumberController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(selectedCustomerProvider);
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
        FuelTypeDropdown(),
        const SizedBox(height: 20),
        AmountQuantityRow(
          amountController: amountController,
          quantityController: quantityController,
        ),
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
        SizedBox(
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
              ref.read(submitIndentProvider.notifier).submitIndent(
                    amount: amountController.text,
                    quantity: quantityController.text,
                    indentNumber: indentNumberController.text,
                  );
            },
            child: const Text(
              "Submit for Approval",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
