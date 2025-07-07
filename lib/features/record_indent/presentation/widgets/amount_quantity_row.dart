import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/record_indent/presentation/providers/providers.dart';
import 'package:fuel_pro_360/shared/constants/app_constants.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';
import 'package:fuel_pro_360/utils/validators.dart';

class AmountQuantityRow extends ConsumerWidget {
  AmountQuantityRow({super.key});

  final TextEditingController amountController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  onAmountChanged(double fuelPrice, String value, WidgetRef ref) {
    double amount = double.tryParse(value) ?? 0.0;

    var quantity = (amount / fuelPrice).toStringAsFixed(2);

    ref.read(quantityProvider.notifier).state = quantity;
    ref.read(amountProvider.notifier).state = value;
    quantityController.text = quantity;
  }

  onQuantityChanged(double fuelPrice, String value, WidgetRef ref) {
    double quantity = double.tryParse(value) ?? 0.0;

    var amount = (quantity * fuelPrice).toStringAsFixed(2);

    ref.read(amountProvider.notifier).state = amount;
    ref.read(quantityProvider.notifier).state = value;
    amountController.text = amount;
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
                      ref,
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
                      onQuantityChanged(
                        selectedFuel?.currentPrice ?? 0,
                        value,
                        ref,
                      );
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
