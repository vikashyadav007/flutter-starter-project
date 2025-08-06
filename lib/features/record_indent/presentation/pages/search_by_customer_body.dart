import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/amount_quantity_row.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/fuel_type_droopdown.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/indent_dropdown.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/no_indent_checkbox.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/record_indent_bottom.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/search_by_indent.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/widgets/vehicle_dropdown.dart';

class SearchByCustomerBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(selectedCustomerProvider);
    final selectedIndent = ref.watch(selectedIndentBookletProvider);
    final noIndentCheckbox = ref.watch(noIndentCheckboxProvider);

    return Container(
      child: Column(children: [
        if (selectedCustomer != null) ...[
          VehicleDropdown(),
          const SizedBox(height: 20),
          NoIndentCheckbox(),
          const SizedBox(height: 20),
          if (noIndentCheckbox == false) ...[
            IndentBookletDropdown(),
            const SizedBox(height: 20),
          ],
          if (selectedIndent != null && noIndentCheckbox == false) ...[
            SearchByIndent(
              source: 1,
            ),
            const SizedBox(height: 20),
          ],
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
