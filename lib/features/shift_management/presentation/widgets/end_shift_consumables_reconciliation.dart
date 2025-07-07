import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fuel_pro_360/features/shift_management/domain/entity/consumables_reconciliation.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/providers/provider.dart';
import 'package:fuel_pro_360/features/shift_management/presentation/widgets/consumables_reconciliation_editor.dart';
import 'package:fuel_pro_360/shared/constants/app_constants.dart';
import 'package:fuel_pro_360/shared/constants/ui_constants.dart';

class EndShiftConsumablesReconciliation extends ConsumerWidget {
  const EndShiftConsumablesReconciliation({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftConsumables = ref.watch(
      shiftConsumablesProvider,
    );
    return shiftConsumables.when(data: (data) {
      if (data.isEmpty) {
        return SizedBox();
      }
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: UiColors.yellowColor.withAlpha(100),
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: UiColors.gray.withAlpha(100), width: 0.4)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Consumables Reconciliation",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: UiColors.gray.withAlpha(100), width: 0.4),
              ),
              child: Column(
                children: [
                  const ConsumablesReconciliationEditor(),
                  Consumer(builder: (consumer, ref, context) {
                    final consumablesReconciliation =
                        ref.watch(consumablesReconciliationProvider);
                    double totalSold = 0;
                    for (var consumable in consumablesReconciliation) {
                      totalSold += (consumable.soldPrice ?? 0);
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Consumables Sold:',
                            style: TextStyle(
                                color: UiColors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14)),
                        Text(
                            '(${Currency.rupee}${totalSold.toStringAsFixed(2)})',
                            style: const TextStyle(
                                color: UiColors.paidGreen,
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                      ],
                    );
                  }),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      );
    }, error: (error, stackTrace) {
      return Center(
        child: Text(
          'Error: $error',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      );
    }, loading: () {
      return const Center(
        child: CircularProgressIndicator(),
      );
    });
  }
}
