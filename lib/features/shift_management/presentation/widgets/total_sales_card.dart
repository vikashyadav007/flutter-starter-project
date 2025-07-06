import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starter_project/features/record_indent/presentation/providers/providers.dart';
import 'package:starter_project/features/shift_management/domain/entity/pump_closing_readings.dart';
import 'package:starter_project/features/shift_management/presentation/providers/provider.dart';
import 'package:starter_project/shared/constants/app_constants.dart';
import 'package:starter_project/shared/constants/ui_constants.dart';
import 'package:starter_project/shared/utils/utils.dart';

class TotalSalesCard extends ConsumerWidget {
  Widget divider() {
    return const Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Divider(thickness: 0.4, color: UiColors.gray),
    );
  }

  Widget fuelSalesRow({
    required BuildContext context,
    required PumpClosingReadings pumpClosingReading,
  }) {
    return Consumer(builder: (context, ref, child) {
      final fuletypeMap = ref.watch(fuelTypesMapProvider);

      double fuelPrice =
          fuletypeMap[pumpClosingReading.reading.fuelType]?.currentPrice ?? 0;

      return Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '${pumpClosingReading.reading.fuelType} sales:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${pumpClosingReading.totalLiters} L',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          )),
                  if (pumpClosingReading.testingFuelReading.isNotEmpty)
                    Text(
                        '(testing: ${pumpClosingReading.testingFuelReading} L)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600, color: UiColors.gray)),
                ],
              ),
            ),
            Expanded(
                child: Text(
              '₹${getCommaSeperatedNumberDouble(number: (double.tryParse(pumpClosingReading.totalLiters) ?? 0.0) * fuelPrice).toString()}',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            )),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pumpClosingReadings = ref.watch(pumpClosingReadingsProvider);
    final cardSales = ref.watch(cardSalesProvider);
    final upiSales = ref.watch(upiSalesProvider);
    final cashSales = ref.watch(cashSalesProvider);
    final otherSales = ref.watch(otherSalesProvider);
    final indentSales = ref.watch(indentSalesProvider);
    final fuelTypesMap = ref.watch(fuelTypesMapProvider);

    print("objects from fuelTypesMap: $fuelTypesMap");

    double totalLitersSold = 0.0;
    double totalSales = 0.0;
    for (var reading in pumpClosingReadings) {
      if (reading.closingReading.isNotEmpty) {
        totalLitersSold += double.tryParse(reading.totalLiters) ?? 0.0;
        totalSales += ((double.tryParse(reading.totalLiters) ?? 0.0) *
            (fuelTypesMap[reading.reading.fuelType]?.currentPrice ?? 0.0));
      }
    }

    double totalPayments = 0.0;
    totalPayments += double.tryParse(cardSales) ?? 0.0;
    totalPayments += double.tryParse(upiSales) ?? 0.0;
    totalPayments += double.tryParse(cashSales) ?? 0.0;
    totalPayments += double.tryParse(otherSales) ?? 0.0;
    totalPayments += double.tryParse(indentSales) ?? 0.0;

    double difference = totalSales - totalPayments;

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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 10),
          ...pumpClosingReadings.asMap().entries.map(
                (entry) => fuelSalesRow(
                  context: context,
                  pumpClosingReading: entry.value,
                ),
              ),
          divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calculated Total:',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(
                '${Currency.rupee} ${totalSales.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
          if (difference != 0)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Difference:',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: UiColors.red),
                ),
                Text(
                  '${Currency.rupee} ${difference.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: UiColors.red, fontWeight: FontWeight.w600),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
