import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/utils/utils.dart';

class TotalSalesCard extends ConsumerWidget {
  Widget divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(thickness: 0.4, color: UiColors.gray),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pumpClosingReadings = ref.watch(pumpClosingReadingsProvider);
    final cardSales = ref.watch(cardSalesProvider);
    final upiSales = ref.watch(upiSalesProvider);
    final cashSales = ref.watch(cashSalesProvider);
    final otherSales = ref.watch(otherSalesProvider);
    final indentSales = ref.watch(indentSalesProvider);
    final testingFuelReading = ref.watch(testingFuelReadingProvider);

    double totalLitersSold = 0.0;
    for (var reading in pumpClosingReadings) {
      if (reading.closingReading.isNotEmpty) {
        totalLitersSold += double.tryParse(reading.totalLiters) ?? 0.0;
      }
    }

    double totalPayments = 0.0;
    totalPayments += double.tryParse(cardSales) ?? 0.0;
    totalPayments += double.tryParse(upiSales) ?? 0.0;
    totalPayments += double.tryParse(cashSales) ?? 0.0;
    totalPayments += double.tryParse(otherSales) ?? 0.0;
    totalPayments += double.tryParse(indentSales) ?? 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withAlpha(30),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withAlpha(300),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Liters Sold:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '${totalLitersSold.toStringAsFixed(2)} L',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Payments:',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '₹${getCommaSeperatedNumber(number: totalPayments.toInt())}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800, color: UiColors.textBluecolor),
              ),
            ],
          ),
          divider(),
          Text(
            'Fuel Sales Breakdown:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
