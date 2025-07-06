import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/amount_quantity_row.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/fuel_type_droopdown.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/record_indent_bottom.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/indent_dropdown.dart';
import 'package:starter_project/features/record_indent/presentation/widgets/vehicle_dropdown.dart';

class SearchByIndentBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(selectedCustomerProvider);
    final selectedIndent = ref.watch(selectedIndentBookletProvider);
    return Container(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (selectedCustomer != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Text("Selected Customer: ${selectedCustomer.name}"),
          ),
          VehicleDropdown(),
          const SizedBox(height: 20),
          IndentBookletDropdown(),
          const SizedBox(height: 20),
          FuelTypeDropdown(),
          const SizedBox(height: 20),
          AmountQuantityRow(),
          const SizedBox(height: 20),
          RecordIndentBottom(),
        ],
      ]),
    );
  }
}
