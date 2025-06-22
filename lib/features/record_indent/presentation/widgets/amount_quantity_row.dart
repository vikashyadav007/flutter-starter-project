import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/selected_fuel_type.dart';
import 'package:starter_project/shared/constants/app_constants.dart';
import 'package:starter_project/shared/widgets/custom_text_field.dart';
import 'package:starter_project/shared/widgets/text_field_label.dart';
import 'package:starter_project/utils/validators.dart';

class AmountQuantityRow extends ConsumerWidget {
  TextEditingController amountController;
  TextEditingController quantityController;
  AmountQuantityRow({
    super.key,
    required this.amountController,
    required this.quantityController,
  });

  onAmountChanged(double fuelPrice, String value) {
    double amount = double.tryParse(value) ?? 0.0;

    quantityController.text = (amount / fuelPrice).toStringAsFixed(2);
  }

  onQuantityChanged(double fuelPrice, String value) {
    double quantity = double.tryParse(value) ?? 0.0;

    amountController.text = (quantity * fuelPrice).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFuel = ref.watch(selectedFuelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextFieldLabel(label: 'Amount(${Currency.rupee})'),
                  CustomTextField(
                    hintText: '0',
                    validator: Validators.validateAmount,
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) => onAmountChanged(
                      selectedFuel?.currentPrice ?? 0,
                      value,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextFieldLabel(label: 'Quantity(L)'),
                  CustomTextField(
                    hintText: '0',
                    validator: Validators.validateAmount,
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      onQuantityChanged(selectedFuel?.currentPrice ?? 0, value);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        selectedFuel == null
            ? const SizedBox.shrink()
            : Text(
                'Current price: ${Currency.rupee} ${selectedFuel.currentPrice}/L',
                style: const TextStyle(fontSize: 12),
              ),
      ],
    );
  }
}
