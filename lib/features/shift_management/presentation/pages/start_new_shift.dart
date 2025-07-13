import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_cart.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/start_new_shift_provider.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/add_consumables_listing.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/consumables_dropdown.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/opening_readings.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/pump_dropdown.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/staff_dropdown.dart';
import 'package:fuel_pro_360/shared/utils/methods.dart';
import 'package:fuel_pro_360/shared/widgets/custom_text_field.dart';
import 'package:fuel_pro_360/shared/widgets/text_field_label.dart';
import 'package:fuel_pro_360/shared/widgets/title_header.dart';
import 'package:fuel_pro_360/utils/validators.dart';

class StartNewShift extends ConsumerWidget {
  TextEditingController amountController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  bool checkInitialReadings(WidgetRef ref) {
    final pumpNozzleReadings = ref.watch(pumpNozzleReadingsProvider);
    for (var reading in pumpNozzleReadings) {
      if (reading.currentReading.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          invalidateActiveShifts(ref: ref);
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: const EdgeInsets.all(20),
            height: double.infinity,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                TitleHeader(
                  title: 'Start New Shift',
                  onBackPressed: () {
                    invalidateActiveShifts(ref: ref);
                  },
                  showLogoutButton: false,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView(
                    children: [
                      StaffDropdown(),
                      const SizedBox(height: 10),
                      PumpDropdown(),
                      const SizedBox(height: 10),
                      Consumer(builder: (context, ref, child) {
                        final startingCashAmount =
                            ref.watch(startingCashAmountProvider);
                        amountController.text = startingCashAmount;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextFieldLabel(label: 'Starting Cash Amount'),
                            CustomTextField(
                                hintText: 'Enter starting cash amount',
                                validator: Validators.validateAmount,
                                controller: amountController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) => {
                                      ref
                                          .read(startingCashAmountProvider
                                              .notifier)
                                          .state = value,
                                    }),
                          ],
                        );
                      }),
                      OpeningReadings(),
                      const SizedBox(height: 10),
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
                                          .read(
                                              selectedQuantityProvider.notifier)
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
                                final selectedQuantity =
                                    ref.watch(selectedQuantityProvider);

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
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                        ),
                                        onPressed: selectedQuantity == '' ||
                                                selectedConsumable == null ||
                                                quantity <= 0 ||
                                                quantity >
                                                    (selectedConsumable
                                                            .quantity ??
                                                        0)
                                            ? null
                                            : () {
                                                consumablesCartState.state = [
                                                  ...consumablesCartState.state,
                                                  ConsumablesCart(
                                                    consumables:
                                                        selectedConsumable,
                                                    quantity: int.parse(
                                                        selectedQuantity),
                                                  ),
                                                ];

                                                ref
                                                    .read(
                                                        selectedConsumableProvider
                                                            .notifier)
                                                    .state = null;
                                                ref
                                                    .read(
                                                        selectedQuantityProvider
                                                            .notifier)
                                                    .state = '1';

                                                print(
                                                    "consumablesCartState.state.length: ${consumablesCartState.state.length}");
                                              },
                                        child: const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: OutlinedButton(
                                onPressed: () {
                                  // Handle cancel action
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  side: const BorderSide(color: Colors.black12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Consumer(builder: (context, ref, child) {
                              final selectedStaff =
                                  ref.watch(selectedStaffProvider);
                              final selectedPump =
                                  ref.watch(selectedPumpProvider);

                              final startCashAmount =
                                  ref.watch(startingCashAmountProvider);

                              return SizedBox(
                                height: 48,
                                width: 50,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  onPressed: selectedStaff == null ||
                                          selectedPump == null ||
                                          startCashAmount.isEmpty ||
                                          checkInitialReadings(ref) == false
                                      ? null
                                      : () {
                                          ref
                                              .read(startNewShiftProvider
                                                  .notifier)
                                              .creaetNewShift();
                                        },
                                  child: const Text(
                                    "Start Shift",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
