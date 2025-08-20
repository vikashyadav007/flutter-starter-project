import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/shared/constants/app_constants.dart';
import 'package:fuel_pro_360/shared/providers/providers.dart';

class AddConsumablesListing extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final consumablesCartState = ref.watch(consumablesCartProvider);
    final totalConsumablesCost = ref.watch(totalConsumablesCostProvider);

    return consumablesCartState.isEmpty
        ? const SizedBox()
        : Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                ...List.generate(
                  consumablesCartState.length,
                  (index) {
                    final consumableCart = consumablesCartState[index];
                    return Container(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                consumableCart.consumables?.name ?? "Unknown",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                  "${consumableCart.quantity} pieces x ${Currency.rupee}${consumableCart.consumables?.pricePerUnit ?? 0}"),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              ref.read(consumablesCartProvider.notifier).state =
                                  consumablesCartState
                                      .where((item) => item != consumableCart)
                                      .toList();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Divider(thickness: 1, color: Colors.grey.shade300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total Cost: ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "${Currency.rupee}${totalConsumablesCost.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
