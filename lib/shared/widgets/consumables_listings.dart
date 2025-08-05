import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_cart.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/consumables_dropdown.dart';
import 'package:fuel_pro_360/shared/widgets/add_consumables_listing.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';
import 'package:fuel_pro_360/utils/validators.dart';

class ConsumablesListings extends ConsumerWidget {
  TextEditingController quantityController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: ConsumablesDropdown(),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextFieldLabel(label: 'Quantity'),
                  Consumer(
                    builder: (context, ref, child) {
                      final selectedQuantity =
                          ref.watch(selectedQuantityProvider);

                      quantityController.text = selectedQuantity;

                      return CustomTextField(
                        hintText: '1',
                        validator: Validators.validateQuantity,
                        controller: quantityController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) => ref
                            .read(selectedQuantityProvider.notifier)
                            .state = value,
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Consumer(
                builder: (context, ref, child) {
                  final selectedConsumable =
                      ref.watch(selectedConsumableProvider);
                  final selectedQuantity = ref.watch(selectedQuantityProvider);

                  final consumablesCartState =
                      ref.watch(consumablesCartProvider.notifier);

                  int quantity = 0;
                  if (selectedQuantity.isNotEmpty) {
                    quantity = int.parse(selectedQuantity);
                  }

                  return Column(
                    children: [
                      const TextFieldLabel(label: ''),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                          ),
                          onPressed: selectedQuantity == '' ||
                                  selectedConsumable == null ||
                                  quantity <= 0 ||
                                  quantity > (selectedConsumable.quantity ?? 0)
                              ? null
                              : () {
                                  consumablesCartState.state = [
                                    ...consumablesCartState.state,
                                    ConsumablesCart(
                                      consumables: selectedConsumable,
                                      quantity: int.parse(selectedQuantity),
                                    ),
                                  ];

                                  ref
                                      .read(selectedConsumableProvider.notifier)
                                      .state = null;
                                  ref
                                      .read(selectedQuantityProvider.notifier)
                                      .state = '1';

                                  print(
                                      "consumablesCartState.state.length: ${consumablesCartState.state.length}");
                                },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        AddConsumablesListing(),
      ],
    );
  }
}
